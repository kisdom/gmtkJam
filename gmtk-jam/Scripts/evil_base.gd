extends TextureButton

signal action_requested(base_node, action_type)

@onready var panel_container: PanelContainer = $PanelContainer


var isPressed: bool = false
var isEvil: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass
		
func _send_rocket():
	pass		
	
func _base_destruction() -> void:
	print(name + " destroyed")
	texture_normal = load("res://gmtk-jam/resources/fire.jpg")
	scale = Vector2(1,1)
	disabled = true
