extends TextureRect

@export var image : String = ""
@export var path = ""

func _ready() -> void:
	find_image()

var allImages = [
	{"image": "1", "path": "res://asset/art/Dee/ArikaSifukuTere.png"},
	{"image": "2", "path": "res://asset/icons/avatar_circle_test.png"}
]

# Convertir el array en un diccionario para búsquedas rápidas
func find_image():
	
	if image == "selfie":
		path = GlobalStats.selfie_image
		texture = load(GlobalStats.selfie_image)
	else:
		var image_paths = {}
		for img_data in allImages:
			image_paths[img_data["image"]] = img_data["path"]

		# Obtener el path directamente
		path = image_paths.get(image, "")
		if image != "":
			texture = load(path)
		#print(path)  # Output: "res://asset/art/Dee/ArikaSifukuTere.png"

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("left_click"):
		ShowImage.show_image(path)
