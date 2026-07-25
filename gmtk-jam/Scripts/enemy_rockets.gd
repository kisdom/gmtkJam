extends Node

@onready var map: Node2D = $"../Map"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_doom_rocket_countdown_timeout() -> void:
	var enemy_bases = []
	var friendly_bases  = []
	var start
	var target
	for base in map.get_child(0).get_node("Bases").get_children():
		if (base.isEvil == true && base.visible == true):
			enemy_bases.append(base)
		elif (base.isEvil == false && base.visible == true)	:
			friendly_bases.append(base)
	var number_of_bases = enemy_bases.size()
	var baseInstance = randi() % number_of_bases
	start = enemy_bases[baseInstance]
	
	number_of_bases = friendly_bases.size()
	baseInstance = randi() % number_of_bases
	target = friendly_bases[baseInstance]
	
	SignalBus.enemy_rocket_launch.emit(start, target)
