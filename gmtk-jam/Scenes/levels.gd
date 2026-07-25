extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_1_pressed() -> void:
	SignalBus.level1_selected.emit()
	queue_free()


func _on_level_2_pressed() -> void:
	SignalBus.level2_selected.emit()
	queue_free()


func _on_level_3_pressed() -> void:
	SignalBus.level3_selected.emit()
	queue_free()


func _on_level_4_pressed() -> void:
	SignalBus.level4_selected.emit()
	queue_free()
