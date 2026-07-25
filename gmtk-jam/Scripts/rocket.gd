extends Path2D

# --- INSPECTOR BEÁLLÍTÁSOK ---
@export var acceleration_profile: Curve # Gyorsulási profil (Curve Presets: Ease In, Ease Out, etc.)
@export var base_speed: float = 200.0   # Alapsebesség (pixel / sec)
@export var max_acceleration: float = 400.0 # Maximális plusz gyorsulás
@export var max_height: float = 600.0   # Az ív csúcspontjának magassága pixelben

# --- CHILD NODE HIVATKOZÁSOK ---
@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var rocket_area: Area2D = $PathFollow2D/Area2D
@onready var line_2d: Line2D = $Line2D

# --- BELSŐ VÁLTOZÓK ---
var current_speed: float = 0.0
var is_flying: bool = false

func launch(start_pos: Vector2, target_pos: Vector2) -> void:
	# A Path2D maga a globális (0, 0) origóhoz igazodik, hogy a pontjai világkoordináták legyenek
	global_position = Vector2.ZERO
	
	# 1. PARABOLAPÁLYA GÖRBE ÉPÍTÉSE (Curve2D generálása kódból)
	var new_curve = Curve2D.new()
	
	# Ív csúcspontja (a kezdő- és végpont felezője felett, Y irányban negatív eltolással)
	var mid_pos = start_pos.lerp(target_pos, 0.5) + Vector2(0, -max_height)
	
	# Pontok hozzáadása a görbéhez
	new_curve.add_point(start_pos)
	new_curve.add_point(mid_pos)
	new_curve.add_point(target_pos)
	
	# Görbület/Kerekítés beállítása a kezdő- és végpontoknál
	new_curve.set_point_out(0, Vector2(0, -max_height * 0.5))
	new_curve.set_point_in(2, Vector2(0, -max_height * 0.5))
	
	self.curve = new_curve
	
	# 2. PIROS NYOMVONAL KIRAJZOLÁSA (Line2D)
	if line_2d:
		line_2d.points = new_curve.get_baked_points()
		print(new_curve.get_baked_points())
	
	# 3. INDÍTÁS
	current_speed = base_speed
	path_follow.progress = 0.0
	is_flying = true

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
		_on_impact()

func _on_impact() -> void:
	is_flying = false
	# Robbanási effekt/hang helye
	queue_free()
	
func self_destruct():
	SignalBus.rocket_destroyed.emit()
	print("Rocket destructed")
	queue_free()
	
	
