extends Node2D
# A visszaszámláló kezdőértéke másodpercben
@export var time_left: float = 60.0
var countdownText: String = "00:05:00"

func _process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		
		# Kerekítés és szép formázás (pl. 01:05)
		var minutes: int = int(time_left) / 60
		var seconds: int = int(time_left) % 60
		countdownText = "%02d:%02d" % [minutes, seconds]
	else:
		time_left = 0
		countdownText = "00:00"
		on_timer_finished()

func on_timer_finished() -> void:
	# Itt adhatod meg, mi történjen, ha lejárt az idő
	print("Lejárt az idő!")
