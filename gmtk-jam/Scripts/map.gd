extends Node2D
@export var rocket_scene: PackedScene
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
	print(base_node.position)
	var rocket = rocket_scene.instantiate()
	add_child(rocket)
	rocket.global_position = base_node.global_position
	#var rocket_spawn_location = rocket.get_node("Path2D/PathFollow2D")
	#rocket_spawn_location.progress_ratio = base_node.global_position
	#rocket.position = rocket_spawn_location
	
func _on_radar_search(base_node):
	pass
