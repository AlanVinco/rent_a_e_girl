extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label
@onready var tween = get_tree().create_tween()

func show_loading():
	color_rect.modulate.a = 0.0
	label.modulate.a = 0.0
	visible = true
	
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	tween.play()

func hide_loading():
	tween = get_tree().create_tween()  # Crea un nuevo tween limpio
	tween.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)  # Estaba en 0.5, deber ser 0.0
	tween.play()
	await tween.finished
	visible = false
