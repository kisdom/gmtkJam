extends Node

@onready var map: Node2D = $".."

var enemy_base_count: int
var friendly_base_count: int

func _ready():
	SignalBus.base_destroyed.connect(_base_destroyed)
	SignalBus.ending_watch.connect(_base_count)
	

func _base_count(friendly_bases: int, enemy_bases: int):
	print("Bases are counted!")
	friendly_base_count = friendly_bases
	enemy_base_count = enemy_bases


func _base_destroyed(base_node):
	print("Check condition")
	if base_node.isEvil:
		enemy_base_count -= 1
		print(enemy_base_count)
		if enemy_base_count == 0:
			SignalBus.ending.emit("win")
	else:
		friendly_base_count -= 1
		print(friendly_base_count)
		if friendly_base_count == 0:
			SignalBus.ending.emit("lost")
