extends Node2D

enum State{
	IDLE,
	ROCKET,
	DEFENSE,
	RADAR
}

@export var defense_line_scene: PackedScene

var state: State = State.IDLE

func _ready() -> void:
	SignalBus.prepare_defense.connect(_on_prepare_defense)
	SignalBus.send_rocket.connect(_on_send_rocket)
	SignalBus.radar_search.connect(_on_radar_search)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_prepare_defense(base_node):
	pass

func _on_send_rocket(base_node):
	pass
	
func _on_radar_search(base_node):
	pass
