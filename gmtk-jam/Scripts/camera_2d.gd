extends Camera2D

# Beállítások (az Inspectorban is módosíthatók)
@export var map_size: Vector2 # A világtérkép (Sprite2D) pixelmérete
@export var drag_sensitivity: float = 1.0   # Húzás érzékenysége
@export var zoom_speed: float = 0.1         # Zoom sebessége lépésenként
@export var min_zoom: float = 0.5           # Legmesszebbi nézet (kicsinyítés)
@export var max_zoom: float = 3.0           # Legközelebbi nézet (nagyítás)

@onready var map_sprite: Sprite2D = $"../Sprite2D"

var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	map_size = map_sprite.texture.get_size() * map_sprite.transform.get_scale()
	# Kiszámoljuk a minimális zoomot, hogy a térkép mindig kitöltse a képernyőt
	_update_min_zoom()
	# Kezdőpozíció korlátozása
	_clamp_camera_position()

# Ha a játékos átméretezi az ablakot, újraszámoljuk a minimális zoomot
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		_update_min_zoom()
		_clamp_camera_position()

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
			
	_move_camera(event)
	_clamp_camera_position()

func _move_camera(event: InputEvent) -> void:
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

# Kiszámolja a legkisebb engedélyezett zoomot a képernyő és a térkép arányából
func _update_min_zoom() -> void:
	var viewport_size = get_viewport_rect().size
	var min_zoom_x = viewport_size.x / map_size.x
	var min_zoom_y = viewport_size.y / map_size.y
	
	# A nagyobb értéket választjuk, hogy egyik tengelyen se látszódjon feketeség
	var absolute_min_zoom = min(min_zoom_x, min_zoom_y)
	
	# Ha a jelenlegi zoom kisebb lenne az új minimumnál, felhúzzuk rá
	if zoom.x < absolute_min_zoom:
		zoom = Vector2(absolute_min_zoom, absolute_min_zoom)

# Ez a függvény nem engedi a kamerát a térkép szélén túlmenni
func _clamp_camera_position() -> void:
	var viewport_size = get_viewport_rect().size
	# A képernyő fele a jelenlegi zoom szinten
	var half_screen = (viewport_size / 2.0) / zoom
	
	# A kamera középpontjának legszélső engedélyezett koordinátái
	var min_x = half_screen.x
	var max_x = map_size.x - half_screen.x
	var min_y = half_screen.y
	var max_y = map_size.y - half_screen.y
	
	# Korlátozzuk a kamera position értékét
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
