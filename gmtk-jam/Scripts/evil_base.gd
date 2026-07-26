extends TextureButton

signal action_requested(base_node, action_type)

@onready var panel_container: PanelContainer = $PanelContainer


var isPressed: bool = false
var isEvil: bool = true

func _ready() -> void:
	_set_random_base_image()
	
func _set_random_base_image() -> void:
	# Fontos: Ellenőrizd a pontos útvonalat! Lehet, hogy "res://gmtk-jam/resources/bases/base/" kell neked.
	var folder_path = "res://gmtk-jam/resources/bases/enemy_base/"
	
	# Lekérjük a mappa tartalmát
	var files = DirAccess.get_files_at(folder_path)
	var valid_images = []
	
	for file in files:
		# Leszedjük a .import kiterjesztést, ha exportált buildről van szó
		var clean_file = file.replace(".import", "")
		
		# Csak a képfájlokat engedjük be a listába
		if clean_file.ends_with(".png") or clean_file.ends_with(".jpg") or clean_file.ends_with(".webp"):
			if not valid_images.has(clean_file):
				valid_images.append(clean_file)
				
	# Ha találtunk képet, véletlenszerűen választunk egyet
	if valid_images.size() > 0:
		var random_image = valid_images.pick_random()
		
		# 1. Rátöltjük a képet a Sprite2D-re a gomb textúrája helyett!
		$Sprite2D.texture = load(folder_path + random_image)
		
	else:
		print("Hiba: Nem találtam képeket ebben a mappában: " + folder_path)
	
func _base_destruction() -> void:
	print(name + " destroyed")
	
	# 1. Rátöltjük a tüzet a Sprite2D-re! 
	# (Mivel a Sprite2D középre van igazítva, a mérettől függetlenül jó helyen lesz)
	$Sprite2D.texture = load("res://gmtk-jam/resources/fire.png")
	
	# Ha van SignalBus bekötésed (a korábbi kódjaid alapján), azt is elsütjük
	SignalBus.base_destroyed.emit(self)
