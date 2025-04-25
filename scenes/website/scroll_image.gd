extends ScrollContainer

@export var image_paths: Array[String] = ["res://asset/icons/avatar_circle_test.png","res://asset/icons/dolaricon-no_bg.png","res://asset/icons/dolaricon-no_bg.png","res://asset/icons/dolaricon-no_bg.png","res://asset/icons/dolaricon-no_bg.png","res://asset/icons/dolaricon-no_bg.png","res://asset/icons/dolaricon-no_bg.png","res://asset/icons/dolaricon-no_bg.png"]  # Rutas de imágenes originales
@onready var hbox = $HBoxContainer

var total_images = 0
var single_image_width = 0

func _ready():
	setup_images()
	await get_tree().process_frame
	single_image_width = hbox.get_child(0).size.x
	scroll_horizontal = single_image_width * image_paths.size()

func setup_images():
	# Limpia hijos anteriores
	for child in hbox.get_children():
		child.queue_free()

	# Duplicamos: [final] + originales + [inicio]
	var full_list = image_paths.duplicate()
	full_list.insert(0, image_paths[-1])  # Última al inicio
	full_list.append(image_paths[0])      # Primera al final
	total_images = full_list.size()

	for path in full_list:
		var tex = load(path)
		var img = TextureRect.new()
		img.texture = tex
		img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		img.custom_minimum_size = Vector2(200, 200)
		hbox.add_child(img)


func _process(_delta):
	var scroll_x = scroll_horizontal
	var image_count = image_paths.size()

	if scroll_x <= 0:
		scroll_horizontal = single_image_width * image_count
	elif scroll_x >= single_image_width * (image_count + 1):
		scroll_horizontal = single_image_width
