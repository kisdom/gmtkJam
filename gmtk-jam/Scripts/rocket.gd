extends Node2D
#var curve = 0.5
#var t = 0.0
#var rocket_path: Curve2D
#var launch_point
var target_point
var speed = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func launch(start_position: Vector2, target: TextureButton):
	#var q0 = start_position.lerp(north_pole_position, curve)
	#var q1 = north_pole_position.lerp(target.global_position, curve)
	#var r = q0.lerp(q1, curve)
	#print(r)
	var tween = get_tree().create_tween()
	target_point = target.global_position
	tween.tween_property(self, "position", target_point, speed)
	await tween.finished
	SignalBus.base_destroyed.emit(target)
	print("signal emitted")
	queue_free()
	
	
