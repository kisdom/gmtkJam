extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.rocket_destroyed.connect(_rocket_explosion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _rocket_explosion():
	playing = false
	stream = load("res://gmtk-jam/resources/446625__idkmrgarcia__explosion.wav")
	playing = true
