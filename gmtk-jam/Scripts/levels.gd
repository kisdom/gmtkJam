extends Control

@onready var map: Node2D = $"../Map"
@onready var camera = $Camera2D

@onready var current_level_label = $current_level

enum Difficulty{
	EASY,
	MEDIUM,
	HARD
}

var current_difficulty = Difficulty.EASY
var selected_level: String = ""
var levels = ["Level1","Level2","Level3", "MiddleEarthMap"]
var current_level = 0:
	set(value):
		current_level = value
		current_level %= 4
		if current_level_label:
			current_level_label.text = "Level:" + levels[current_level]

var enemy_base_count = 0
var friendly_base_count = 0

func play_current_level():
	change_level(levels[current_level])
	SignalBus.level_relay.emit(selected_level)
	
func next_level():
	current_level += 1
	
func previous_level():
	current_level -= 1

func _ready() -> void:
	pass
	
func _check_difficulty() -> void:
	if selected_level == "Level1":
		current_difficulty = Difficulty.EASY
	elif selected_level == "Level2":
		current_difficulty = Difficulty.MEDIUM
	if selected_level == "Level3" || selected_level == "MiddleEarthMap" :
		current_difficulty = Difficulty.HARD	

func change_level(level_name: String):
	if selected_level != "":
		unload_level(selected_level)
		
	_load_level(level_name)
	selected_level = level_name
	_check_difficulty()
	SignalBus.difficulty_changed.emit(current_difficulty)
	current_level_label.text = selected_level
	map.show()
	hide()
	camera.enabled = false
	

func unload_level(level_name: String):
	# Mivel már a Map alatt van, csak megkeressük és elrejtjük
	var level_node = map.get_node(level_name)
	level_node.hide() 
	
	# Ha akarod, itt kikapcsolhatod a bázisokat is, hogy ne kattinthass rájuk véletlenül láthatatlanul
	if level_node.has_node("Bases"):
		for base in level_node.get_node("Bases").get_children():
			base.disabled = true

func _load_level(level_name: String):
	# Megkeressük a Map alatt, és egyszerűen láthatóvá tesszük
	var level_node = map.get_node(level_name)
	level_node.show()
	
	# Opcionális: Ha akarod, a move_child-al továbbra is előre hozhatod, hogy ne takarjon ki semmit
	map.move_child(level_node, 0)
	
	# Bázisok aktiválása
	if level_node.has_node("Bases"):
		var bases = level_node.get_node("Bases") 
		for base in bases.get_children():
			base.show() 
			base.disabled = false
			if base.isEvil:
				enemy_base_count += 1
			else:
				friendly_base_count += 1
				
		
	if level_node.has_node("Sprite2D"):
		var sprite = level_node.get_node("Sprite2D")
		sprite.show()
		
	# 3.5 Looking for win condition
	SignalBus.ending_watch.emit(friendly_base_count, enemy_base_count)
		
		
	# Enemy activation
	$"../DoomRocketCountdown".start()


func _on_next_pressed():
	next_level()


func _on_prev_pressed():
	previous_level()
	

func _on_map_button_pressed():
	play_current_level()


func _on_exit_pressed():
	get_tree().quit()	


func _on_texture_button_pressed() -> void:
	SignalBus.tutorial_activated.emit()
