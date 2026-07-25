extends Control

@onready var map: Node2D = $"../Map"
var selected_level: String = ""

func _ready() -> void:
	pass

func _on_level_1_pressed() -> void:
	change_level("Level1")
	hide()

func _on_level_2_pressed() -> void:
	change_level("Level2")
	hide()

func _on_level_3_pressed() -> void:
	change_level("Level3")
	hide()

func _on_level_4_pressed() -> void:
	change_level("MiddleEarthMap")
	hide()

func change_level(level_name: String):
	if selected_level != "":
		unload_level(selected_level)
		
	_load_level(level_name)
	selected_level = level_name
	map.show()

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
