extends Control

var current_level: String = "menu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.ending.connect(_show_ending)
	SignalBus.level_relay.connect(_set_level)
	SignalBus.tutorial_activated.connect(_show_manual)

func _show_manual():
	get_tree().paused = true
	$CanvasLayer.visible = true
	$CanvasLayer/Button.visible = true
	$CanvasLayer/Button.disabled = false
	
	$CanvasLayer/ColorRect/Label.text = "Hold down the right mouse button
	to move around the map.
	By hovering your mouse over a base, you can
	activate one of its defense mechanisms.
	Defense creates a line with two mouse clicks,
	able to withstand three rocket strikes.
	Rocket sends out a rocket.
	Destroy their bases, before yours are
	destroyed!"
		

func _set_level(level: String):
	current_level = level
	get_tree().paused = true
	$CanvasLayer.visible = true
	$CanvasLayer/Button.visible = true
	$CanvasLayer/Button.disabled = false
	
	if(current_level == "MiddleEarthMap"):
		$CanvasLayer/ColorRect/Label.text = "You are tasked to defend the last base,
		until the space shuttle is ready to launch.
		Survive!"
	elif(current_level == "Level1"):
		$CanvasLayer/ColorRect/Label.text = "All out nuclear war has broken out.
		Destroy their bases before
		they can destroy yours!"
	elif(current_level == "Level2"):
		$CanvasLayer/ColorRect/Label.text = "The stakes are much higher now.
		But I am sure you can prevail."
	elif(current_level == "Level3"):
		$CanvasLayer/ColorRect/Label.text = "The end has come!
		The only question remaining is,
		for whom?"
	
func _show_ending(ending_type: String):
	get_tree().paused = true
	$CanvasLayer.visible = true
	print(current_level)
	if (ending_type == "lost"): #all bases destroyed
		if(current_level == "MiddleEarthMap"):
			$CanvasLayer/ColorRect/Label.text = "Leaving you here to die...
			They might as well share in your fate."
		elif(current_level == "Level3"):
			$CanvasLayer/ColorRect/Label.text = "Honor is dead...
			and so am I..."
		else:	
			$CanvasLayer/ColorRect/Label.text = "You have fought valiantly, but it has
		 	been for naught...
			All is destroyed and consumed by
			the flames of war.
		 	Rest now, for the end has come..."

	elif (ending_type == "win"): # all enemy bases destroyed
		if(current_level == "MiddleEarthMap"):
			$CanvasLayer/ColorRect/Label.text = "It was supposed to be your
			last defense...
			Instead it was their last offense."
		else:	
			$CanvasLayer/ColorRect/Label.text = "You are a winner...?
			But at what cost...?"
		
	elif (ending_type == "time"): # time is up
		if(current_level == "MiddleEarthMap"):
			$CanvasLayer/ColorRect/Label.text = "As you defend your base to the bitter end
			your fellow comrades are given a chance
			 to retreat into space and start a new life.
			
			A memorial will be granted to you."	
		
		elif(current_level != "menu"):
			$CanvasLayer/ColorRect/Label.text = "A war without end...
			You prepare to launch your last rocket,
			but it is already too late.
			The Earth is now destroyed.
			You have just lost the game."	
		else:
			$CanvasLayer/ColorRect/Label.text = "Never interrupt your enemy
			when he is making a mistake.
									- Napoleon Bonaparte"


func _on_button_pressed() -> void:
	get_tree().paused = false
	$CanvasLayer.visible = false
	$CanvasLayer/Button.visible = false
	$CanvasLayer/Button.disabled = true
