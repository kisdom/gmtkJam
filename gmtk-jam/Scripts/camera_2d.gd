extends Camera2D

# Beállítások (az Inspectorban is módosíthatók)
@export var drag_sensitivity: float = 1.0   # Húzás érzékenysége
@export var zoom_speed: float = 0.1         # Zoom sebessége lépésenként
@export var min_zoom: float = 0.5           # Legmesszebbi nézet (kicsinyítés)
@export var max_zoom: float = 3.0           # Legközelebbi nézet (nagyítás)

var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	# --- EGÉR GÖRGŐ: ZOOMOLÁS ---
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_set_zoom_level(zoom + Vector2(zoom_speed, zoom_speed))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_set_zoom_level(zoom - Vector2(zoom_speed, zoom_speed))

	# --- KORNYEZET MOZGATÁSA (DRAG) ---
	# Középső egérgombbal (vagy jobb gombbal, ha átírod) lehet húzni a térképet
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			is_dragging = true
			drag_start_position = event.position
		else:
			is_dragging = false

	# Egérmozgás kezelése húzás közben
	if event is InputEventMouseMotion and is_dragging:
		# A kamera pozícióját ellentétesen mozgatjuk az egér irányával
		position -= (event.position - drag_start_position) * (1.0 / zoom.x) * drag_sensitivity
		drag_start_position = event.position

# Zoom határok kezelése
func _set_zoom_level(new_zoom: Vector2) -> void:
	var clamped_x = clamp(new_zoom.x, min_zoom, max_zoom)
	var clamped_y = clamp(new_zoom.y, min_zoom, max_zoom)
	zoom = Vector2(clamped_x, clamped_y)
