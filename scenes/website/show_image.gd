extends CanvasLayer

func _on_btn_close_pressed() -> void:
	visible = false

func show_image(path):
	$ColorRect/Image.texture = load(path)
	visible = true
