extends Node2D


# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	for base in get_tree().get_nodes_in_group("bases"):
		base.action_requested.connect(_on_base_action_requested)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_base_action_requested(base_node: Variant, action_type: Variant) -> void:
	print(base_node.name)
