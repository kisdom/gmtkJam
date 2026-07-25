extends Node2D

@export var circle_color := Color(0.306, 0.703, 0.925, 0.4) # Félig áttetsző piros
var circle_radius := 100.0

func setup(base_node_pos: Vector2, defense_distance: float) -> void:
	position = base_node_pos
	circle_radius = defense_distance
	# Újrafejleszti a képernyőt, kényszerítve a _draw() lefutását
	queue_redraw()

func _draw() -> void:
	# 1. Teli kör rajzolása (pozíció, sugár, szín)
	draw_circle(Vector2.ZERO, circle_radius, circle_color)
	
	# OPTIONÁLIS: Ha csak a kör vonalát (kerületét) szeretnéd rajzolni, használd ezt:
	# draw_arc(Vector2.ZERO, circle_radius, 0, TAU, 64, circle_color, 2.0)
