extends TextureButton

@onready var panel_container: PanelContainer = $PanelContainer


var isPressed: bool = false
var isEvil: bool = false

func _ready() -> void:
	_set_random_base_image()
	
func _set_random_base_image() -> void:
	# Fontos: Ellenőrizd a pontos útvonalat! Lehet, hogy "res://gmtk-jam/resources/bases/base/" kell neked.
	var folder_path = "res://gmtk-jam/resources/bases/base/"
	
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

func _on_defense_pressed() -> void:
	panel_container.hide()
	SignalBus.prepare_defense.emit(self)

func _on_rocket_pressed() -> void:
	panel_container.hide()
	SignalBus.send_rocket.emit(self)

func _on_radar_pressed() -> void:
	panel_container.hide()
	SignalBus.radar_search.emit(self)
	
func _base_destruction() -> void:
	print(name + " destroyed")
	
	# 1. Rátöltjük a tüzet a Sprite2D-re! 
	# (Mivel a Sprite2D középre van igazítva, a mérettől függetlenül jó helyen lesz)
	$Sprite2D.texture = load("res://gmtk-jam/resources/fire.png")
	
	# Menü elrejtése és gomb letiltása
	$PanelContainer.visible = false
	
	# Ha van SignalBus bekötésed (a korábbi kódjaid alapján), azt is elsütjük
	SignalBus.base_destroyed.emit(self)


func _on_area_2d_mouse_entered() -> void:
	if not disabled:
		panel_container.show()


func _on_area_2d_mouse_exited() -> void:
	panel_container.hide()
