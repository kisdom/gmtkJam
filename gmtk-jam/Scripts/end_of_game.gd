extends Node

@onready var map: Node2D = $".."

var enemy_base_count: int
var friendly_base_count: int

func _ready():
	SignalBus.base_destroyed.connect(_base_destroyed)
	

func setup():
	var bases_node = map.get_child(0).get_node("Bases")
	for base in bases_node.get_children():
		if base.isEvil:
			enemy_base_count += 1
		else:
			friendly_base_count += 1


func _base_destroyed(base_node):
	if base_node.isEvil:
		enemy_base_count -= 1
		if enemy_base_count == 0:
			SignalBus.endig.emit("win")
	else:
		friendly_base_count -= 1
		if friendly_base_count == 0:
			SignalBus.endig.emit("lost")
