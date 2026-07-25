extends TextureButton

signal action_requested(base_node, action_type)

@onready var panel_container: PanelContainer = $PanelContainer


var isPressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	SignalBus.select_base.emit(self)
	isPressed = not isPressed
	if isPressed:
		panel_container.visible = true
	else:
		panel_container.visible = false

func _on_defense_pressed() -> void:
	panel_container.hide()
	SignalBus.prepare_defense.emit(self)

func _on_rocket_pressed() -> void:
	panel_container.hide()
	SignalBus.send_rocket.emit(self)

func _on_radar_pressed() -> void:
	panel_container.hide()
	SignalBus.radar_search.emit(self)
