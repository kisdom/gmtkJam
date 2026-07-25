extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.base_destroyed.connect(_rocket_explosion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _rocket_explosion(_dbase_node):
	playing = false
	stream = load("res://gmtk-jam/resources/446625__idkmrgarcia__explosion.wav")
	playing = true
	print("Base destroyed")
