extends Node2D

enum State{
	IDLE,
	ROCKET,
	DEFENSE,
	RADAR
}

enum DefenseLineState{
	START,
	FINISH
}

@export var rocket_scene: PackedScene
@export var defense_line_scene: PackedScene

var state: State = State.IDLE
var defense_line_sate: DefenseLineState = DefenseLineState.START
# A logika futtatásához szükséges átmeneti változók
var active_base = null
var active_defense_line: Node2D = null
var rocket = null

func _ready() -> void:
	SignalBus.prepare_defense.connect(_on_prepare_defense)
	SignalBus.send_rocket.connect(_on_send_rocket)
	SignalBus.radar_search.connect(_on_radar_search)
	
func _unhandled_input(event: InputEvent) -> void:
	# Mégse akció jobb egérgombbal (vagy ESC-pel)
	if Input.is_action_just_pressed("Space"):
		_cancel_current_action()
		return

	# --- VÉDELMI VONAL RAJZOLÁS (2 kattintásos logika) ---
	if state == State.DEFENSE and active_defense_line != null:
		_draw_defense_line(event)
		
	if state == State.ROCKET:
		_draw_rocket_line(event)
			
# --- BASE SIGNALBUS CALLBACK-EK ---
func _on_prepare_defense(base_node) -> void:
	# Ha már folyamatban volt egy rajzolás, töröljük a félkész vonalat
	_cancel_current_action()
	
	state = State.DEFENSE
	defense_line_sate = DefenseLineState.START
	active_base = base_node
	
	# Létrehozzuk a védelmi vonalat és elindítjuk a bázis pozíciójából
	if defense_line_scene:
		active_defense_line = defense_line_scene.instantiate()
		add_child(active_defense_line)
		active_defense_line.setup(get_base_pos(base_node))

func _on_send_rocket(base_node) -> void:
	_cancel_current_action()
	state = State.ROCKET
	active_base = base_node
	_spawn_rocket(get_base_pos(base_node))
	_set_bases_interactable(false)

func _on_radar_search(base_node) -> void:
	_cancel_current_action()
	state = State.RADAR
	active_base = base_node
	print("Radar keresés indítva innen: ", base_node.name)
	# Itt futtathatod a radar logikádat (pl. felfedi a környező területet)
	state = State.IDLE
	
# --- JÁTÉK LOGIKA ---

func _spawn_rocket(start_pos: Vector2) -> void:
	rocket = rocket_scene.instantiate()
	add_child(rocket)
	rocket.global_position = start_pos
	rocket.setup(start_pos)
	# Ha a rakéta scriptjében van setup/launch függvény:

func _draw_defense_line(event: InputEvent) -> void:
	if defense_line_sate == DefenseLineState.START:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed and active_defense_line.is_in_distance(get_global_mouse_position()):
			active_defense_line.start(get_global_mouse_position())
			defense_line_sate = DefenseLineState.FINISH
	else:
		# Egérmozgás közben követi a vonal végét
		if event is InputEventMouseMotion:
			active_defense_line.update_preview(get_global_mouse_position())
		
		# Második kattintás: vonal letétele és lezárása
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
			active_defense_line.finalize_line()
			active_defense_line = null
			state = State.IDLE
						

func _draw_rocket_line(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		rocket.launch(_get_hovered_base_area())
		# Kilövés megtörtént, visszaállunk alapállapotba:
		state = State.IDLE
		active_base = null
		_set_bases_interactable(true)
	elif event is InputEventMouseMotion:
		rocket.calculate_trajectory(get_global_mouse_position())

func _cancel_current_action() -> void:
	if active_defense_line != null and state == State.DEFENSE:
		active_defense_line.queue_free()
		active_defense_line = null
	
	active_base = null
	state = State.IDLE
	_set_bases_interactable(true)

# --- SEGÉDFÜGGVÉNYEK ---

func get_base_pos(base_node) -> Vector2:
	return base_node.global_position + ((base_node.size / 2.0) * base_node.scale)
			
# Kikapcsolja vagy bekapcsolja a bázisok gomb-funkcióját
func _set_bases_interactable(is_interactable: bool) -> void:
	var bases_node = get_child(0).level_node.get_node("Bases")
	for base in bases_node.get_children():
		if is_interactable:
			# Visszaállítjuk az alapértelmezett állapotot (reagál a kattintásra)
			base.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			# Célzáskor a bázis teljesen "láthatatlan" az egér számára, 
			# így a kattintás továbbmegy a térkép _unhandled_input-jába!
			base.mouse_filter = Control.MOUSE_FILTER_IGNORE

# Visszaadja az egér alatti Bázist (Area2D-t), vagy null-t, ha üres helyre kattintottál
func _get_hovered_base_area() -> TextureButton:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	var results = space_state.intersect_point(query)
	
	for result in results:
		if result.collider is Area2D  and result.collider.owner is TextureButton:
			return result.collider.owner
	return null
