extends Node
enum Difficulty{
	EASY,
	MEDIUM,
	HARD
}
var rocket_spawn_frequency: int = 15
var rocket_cooldown: int = 5
var radar_cooldown: int = 10
var defense_cooldown: int = 15

func _ready() -> void:
	SignalBus.difficulty_changed.connect(difficulty_changed)
	
func difficulty_changed(difficulty: Difficulty):
	if (difficulty == Difficulty.EASY):
		rocket_spawn_frequency = 20
		rocket_cooldown = 2
		radar_cooldown = 5
		defense_cooldown = 10
	elif (difficulty == Difficulty.MEDIUM):
		rocket_spawn_frequency = 15
		rocket_cooldown = 5
		radar_cooldown = 10
		defense_cooldown = 15
	elif (difficulty == Difficulty.HARD):
		rocket_spawn_frequency = 10
		rocket_cooldown = 10
		radar_cooldown = 15
		defense_cooldown = 20
