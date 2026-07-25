extends Node2D
@export var time_left: float = 62.0
var red = Color(1.0,0.0,0.0,1.0)
var yellow = Color(0.845, 0.737, 0.13, 1.0)
var minutes
var seconds

func _process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		minutes = int(time_left) / 60
		seconds = int(time_left) % 60
		$TimerText.text = "%02d:%02d" % [minutes, seconds]
		if (time_left <= 60):
			$TimerText.set("theme_override_colors/font_color",red)
			SignalBus.lastMinute.emit()
		else:
			$TimerText.set("theme_override_colors/font_color",yellow)
	else:
		time_left = 0
		$TimerText.text = "00:00"
		on_timer_finished()

func on_timer_finished() -> void:
	print("Lejárt az idő!")
	SignalBus.worldEnd.emit()

func _on_button_add_time(timeIncrease: int) -> void:
	time_left = time_left + timeIncrease
	$TimerText.text = "%02d:%02d" % [minutes, seconds]
