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
	
	# 1. Áttesszük a map alá (alapból a lista végére kerül)
	level_node.call_deferred("reparent", map, false)
	
	# 2. Utasítjuk a map-et, hogy amint megkapta a node-ot, tegye a 0. indexre!
	map.call_deferred("move_child", level_node, 0)
	
	# 3. Bázisok aktiválása (Egy apró módosítással a biztonság kedvéért!)
	var bases = level_node.get_node("Bases") 
	
	for base in bases.get_children():
		base.show() 
		base.disabled = false
