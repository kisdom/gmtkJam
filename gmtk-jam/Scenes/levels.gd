extends Control

@onready var map: Node2D = $"../Map"
@onready var camera = $Camera2D

@onready var current_level_label = $current_level
var selected_level: String = ""
var levels = ["Level1","Level2","Level3","MiddleEarthMap"]
var current_level = 0:
	set(value):
		current_level = value
		current_level %= 4
		if current_level_label:
			current_level_label.text = "Level:" + levels[current_level]

func play_current_level():
	change_level(levels[current_level])
	
func next_level():
	current_level += 1
	
func previous_level():
	current_level -= 1

func _ready() -> void:
	pass

func change_level(level_name: String):
	if selected_level != "":
		unload_level(selected_level)
		
	_load_level(level_name)
	selected_level = level_name
	current_level_label.text = selected_level
	map.show()
	hide()
	camera.enabled = false
	

func unload_level(level_name: String):
	var level_node = map.get_node(level_name)
	# A reparent áthelyezi a node-ot, a call_deferred pedig garantálja, hogy ez biztonságosan történjen meg
	level_node.call_deferred("reparent", self, false)

func _load_level(level_name: String):
	var level_node = get_node(level_name)
	print(level_node.get_children())
	# Ugyanez a betöltésnél: megvárjuk a frame végét, majd áttesszük a map alá
	level_node.call_deferred("reparent", map, false)
	var Bases = level_node.get_child(0)
	for base in Bases.get_children():
		base.show() 
		base.disabled = false


func _on_next_pressed():
	next_level()


func _on_prev_pressed():
	previous_level()
	

func _on_map_button_pressed():
	play_current_level()


func _on_exit_pressed():
	get_tree().quit()	
