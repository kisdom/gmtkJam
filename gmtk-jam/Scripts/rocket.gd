extends Path2D

# --- INSPECTOR BEÁLLÍTÁSOK ---
@export var acceleration_profile: Curve # Gyorsulási profil (Curve Presets: Ease In, Ease Out, etc.)
@export var base_speed: float = 200.0   # Alapsebesség (pixel / sec)
@export var max_acceleration: float = 400.0 # Maximális plusz gyorsulás
@export var max_curve_height: float = 300.0   # Az ív csúcspontjának magassága pixelben
# Add hozzá ezt a sort! Állítsd be az Inspectorban a világtérképed pontos Y közepére:
@export var map_center_y: float = 540.0

# --- CHILD NODE HIVATKOZÁSOK ---
@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var rocket_area: Area2D = $PathFollow2D/Area2D
@onready var line_2d: Line2D = $Line2D

# --- BELSŐ VÁLTOZÓK ---
var current_speed: float = 0.0
var is_flying: bool = false
var target_base

func launch(start_pos: Vector2, target_pos: Vector2, target: TextureButton) -> void:
	# A Path2D maga a globális (0, 0) origóhoz igazodik, hogy a pontjai világkoordináták legyenek
	global_position = Vector2.ZERO
	
	# Ha a bázisod egy TextureButton, itt a középpontot számoljuk [cite: 337, 339]
	var real_start = start_pos
	var real_target = target_pos
	
	var new_curve = Curve2D.new()
	
	# Távolság és arányos magasság
	var distance = real_start.distance_to(real_target)
	var calculated_height = clamp(distance * 0.3, 50.0, max_curve_height)
	
	# --- 1. A TÜKRÖZÉS LOGIKÁJA ---
	# Megnézzük, hogy az indítási pont a térkép közepe alatt van-e (Godotban a lefelé a +Y)
	var is_bottom_half = real_start.y > map_center_y
	
	# Ha lent van, lefelé domborítunk (+1), ha fent van, felfelé (-1)
	var height_dir = 1.0 if is_bottom_half else -1.0
	
	# A felezőpont eltolva a megfelelő irányba
	var mid_pos = real_start.lerp(real_target, 0.5) + Vector2(0, calculated_height * height_dir)
	
	# PONTOK HOZZÁADÁSA
	new_curve.add_point(real_start)
	new_curve.add_point(mid_pos)
	new_curve.add_point(real_target)
	
	# --- 2. AZ IRÁNYÍTÓKAROK (BEZIER ÉRINTŐK) BEÁLLÍTÁSA ---
	var baseline_dir = (real_target - real_start).normalized()
	var smooth_factor = distance * 0.25
	
	# A csúcsponton (Point 1) a görbe érintője marad az alapvonallal párhuzamos [cite: 348, 349]
	new_curve.set_point_in(1, -baseline_dir * smooth_factor)
	new_curve.set_point_out(1, baseline_dir * smooth_factor)
	
	# A kezdő és végpontokból a height_dir alapján megfelelő irányba (felfelé vagy lefelé) indul az ív
	new_curve.set_point_out(0, Vector2(0, calculated_height * height_dir * 0.5))
	new_curve.set_point_in(2, Vector2(0, calculated_height * height_dir * 0.5))
	
	self.curve = new_curve
	
	# --- 3. PIROS NYOMVONAL FRISSÍTÉSE ---
	if line_2d:
		line_2d.top_level = false
		line_2d.position = Vector2.ZERO
		line_2d.rotation = 0.0
		line_2d.scale = Vector2.ONE
		line_2d.clear_points()
		
		# A beépített get_baked_points() adja a lágy ívet [cite: 394, 395]
		for pt in new_curve.get_baked_points():
			line_2d.add_point(pt)
			
	# --- 4. INDÍTÁS ---
	current_speed = base_speed
	path_follow.progress = 0.0
	is_flying = true
	target_base = target

func _process(delta: float) -> void:
	if not is_flying:
		return
		
	# A haladási arány lekérése (0.0 és 1.0 között)
	var current_ratio: float = path_follow.progress_ratio
	
	# Gyorsulási tényező kiszámítása a görbe alapján
	var accel_factor: float = 0.0
	if acceleration_profile:
		accel_factor = acceleration_profile.sample(current_ratio)
	
	# A gyorsulást hozzáadjuk az aktuális sebességhez (a sebesség mindig pozitív marad, így nem megy hátrafelé)
	current_speed += accel_factor * max_acceleration * delta
	
	# A rakéta léptetése pixelben
	path_follow.progress += current_speed * delta
	
	# Becsapódás ellenőrzése (amikor a pálya végére ért)
	if path_follow.progress_ratio >= 1.0:
		target_base._base_destruction()
		_on_impact()

func _on_impact() -> void:
	is_flying = false
	# Robbanási effekt/hang helye
	SignalBus.rocket_destroyed.emit()
	queue_free()
	
func self_destruct():
	is_flying = false
	SignalBus.rocket_destroyed.emit()
	print("Rocket destructed")
	queue_free()
	
	


func _on_rocket_outer_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Rocket"):
		self_destruct()
