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

func _ready() -> void:
	SignalBus.prepare_defense.connect(_on_prepare_defense)
	SignalBus.send_rocket.connect(_on_send_rocket)
	SignalBus.radar_search.connect(_on_radar_search)
	SignalBus.select_base.connect(_on_select_base)
	
func _unhandled_input(event: InputEvent) -> void:
	# Mégse akció jobb egérgombbal (vagy ESC-pel)
	# if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
	# 	_cancel_current_action()
	# 	return

	# --- VÉDELMI VONAL RAJZOLÁS (2 kattintásos logika) ---
	if state == State.DEFENSE and active_defense_line != null:
		_draw_defense_line(event)
	
# --- BASE SIGNALBUS CALLBACK-EK ---
func _on_select_base(base_node) -> void:
	if state == State.ROCKET:
		_spawn_rocket(active_base.global_position, base_node)
		active_base = null
		state = State.IDLE

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
		active_defense_line.setup(base_node.global_position)

func _on_send_rocket(base_node) -> void:
	_cancel_current_action()
	state = State.ROCKET
	active_base = base_node

func _on_radar_search(base_node) -> void:
	_cancel_current_action()
	state = State.RADAR
	active_base = base_node
	print("Radar keresés indítva innen: ", base_node.name)
	# Itt futtathatod a radar logikádat (pl. felfedi a környező területet)
	state = State.IDLE
	
# --- SEGÉDFÜGGVÉNYEK ---

func _spawn_rocket(start_pos: Vector2, target: TextureButton) -> void:
	var rocket = rocket_scene.instantiate()
	add_child(rocket)
	rocket.global_position = start_pos
	# Ha a rakéta scriptjében van setup/launch függvény:
	rocket.launch(start_pos, target.global_position)

func _draw_defense_line(event: InputEvent) -> void:
	if defense_line_sate == DefenseLineState.START:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed and active_defense_line.is_in_distance(get_global_mouse_position()):
			active_defense_line.start(get_global_mouse_position())
			defense_line_sate = DefenseLineState.FINISH
	else:
		# Egérmozgás közben követi a vonal végét
		if event is InputEventMouseMotion \
		and active_defense_line.is_in_distance(get_global_mouse_position()) \
		and active_defense_line.valid_line_lenght(get_global_mouse_position()):
			active_defense_line.update_preview(get_global_mouse_position())
		
		# Második kattintás: vonal letétele és lezárása
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
			active_defense_line.finalize_line()
			active_defense_line = null
			state = State.IDLE

func _cancel_current_action() -> void:
	if active_defense_line != null and state == State.DEFENSE:
		active_defense_line.queue_free()
		active_defense_line = null
	
	active_base = null
	state = State.IDLE
