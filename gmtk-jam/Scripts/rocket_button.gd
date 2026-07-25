extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = GameVariables.rocket_cooldown
	text = "Rocket"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(disabled == true):
		text = "%3.1f" % $Timer.time_left
	
func _button_pressed():
	disabled = true
	set_process(true)
	$Timer.start()	


func _on_timer_timeout() -> void:
	disabled = false
	set_process(false)
	text = "Rocket"
