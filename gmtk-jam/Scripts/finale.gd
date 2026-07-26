extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.ending.connect(_show_ending)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _show_ending(ending_type: String):
	get_tree().paused = true
	$CanvasLayer.visible = true
	if (ending_type == "lost"): #all bases destroyed
		$CanvasLayer/ColorRect/Label.text = "You have fought valiantly, but but it has been for naught.../n
		All is destroyed and consumed by the flames of war. Rest now, for the end has come..."

	elif (ending_type == "win"): # all enemy bases destroyed
		$CanvasLayer/ColorRect/Label.text = "You are a winner...?/n
		But at what cost...?"
		
	elif (ending_type == "time"): # time is up
		$CanvasLayer/ColorRect/Label.text = "A war without end.../n
		You prepare to launch your last rocket, but it is already too late./n
		The Earth is now destroyed. You have just lost the game."
