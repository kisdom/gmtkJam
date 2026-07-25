extends Node2D

@onready var line_2d: Line2D = $Line2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var defense_circle: Node2D = $defense_circle

@export var DEFENSE_DISTACE: int = 300
@export var DEFENSE_LINE_LENGHT: int = 200

var start_point: Vector2
var end_point: Vector2
var is_placing: bool = true
var base_pos: Vector2

func setup(base_node_pos):
	line_2d.hide()
	base_pos = base_node_pos
	defense_circle.setup(base_pos, DEFENSE_DISTACE)
	defense_circle.show()

func start(start_pos: Vector2) -> void:
	start_point = start_pos
	end_point = start_pos
	line_2d.clear_points()
	line_2d.add_point(start_pos)
	line_2d.add_point(start_pos)
	line_2d.show()

# Ezt a Map hívja meg folyamatosan, amíg mozog az egér
func update_preview(current_mouse_pos: Vector2) -> void:
	if is_placing:
		end_point = current_mouse_pos
		line_2d.set_point_position(1, end_point)

# Ezt hívjuk meg a második kattintáskor (amikor véglegesítjük a vonalat)
func finalize_line() -> void:
	defense_circle.hide()
	is_placing = false
	line_2d.set_point_position(1, end_point)
	
	# Elkészítjük a fizikai szakasz-alakzatot (SegmentShape2D)
	var segment = SegmentShape2D.new()
	segment.a = start_point
	segment.b = end_point
	
	# Hozzárendeljük az Area2D-hez
	collision_shape.shape = segment
	
	# Beállítjuk a csoportot, hogy a rakéta felismerje
	area_2d.add_to_group("defense_lines")

func is_in_distance(pos: Vector2) -> bool:
	return float(DEFENSE_DISTACE) > base_pos.distance_to(pos)
	
func valid_line_lenght(pos: Vector2):
	return float(DEFENSE_LINE_LENGHT) > start_point.distance_to(pos)
