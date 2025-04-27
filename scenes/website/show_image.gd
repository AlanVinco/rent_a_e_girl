extends CanvasLayer

func _on_btn_close_pressed() -> void:
	visible = false

func show_image(path):
	$ColorRect/Image.texture = load(path)
	visible = true
	
func get_path_by_rect(node):
	var path = node.texture.resource_path 
	$ColorRect/Image.texture = load(path)
	visible = true
