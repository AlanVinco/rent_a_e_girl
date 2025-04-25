extends Control

@onready var dot1 = $HBoxContainer/Dot1
@onready var dot2 = $HBoxContainer/Dot2
@onready var dot3 = $HBoxContainer/Dot3

var typing_time: float = 2.0
var playing: bool = false
var tween: Tween

func _ready():
	reset_dots()
	hide()

func play_typing(duration: float):
	AudioManager.loopsound.stream = load("res://audio/sound/Typing sound.mp3")
	AudioManager.loopsound.play()
	typing_time = duration
	show()
	playing = true
	start_typing_animation()

func stop_typing():
	AudioManager.loopsound.stop()
	AudioManager.sound.stream = load("res://audio/sound/send_message_sound.mp3")
	AudioManager.sound.play()
	playing = false
	if tween:
		tween.kill()
	reset_dots()
	hide()

func reset_dots():
	for dot in [dot1, dot2, dot3]:
		dot.scale = Vector2.ONE

func start_typing_animation():
	tween = get_tree().create_tween()
	animate_dots()

func animate_dots() -> void:
	await get_tree().process_frame  # Asegura que todo esté listo
	while playing:
		await animate_dot(dot1)
		if !playing: break
		await animate_dot(dot2)
		if !playing: break
		await animate_dot(dot3)

func animate_dot(dot: Control) -> void:
	reset_dots()
	dot.scale = Vector2(1.0, 1.0)

	tween = get_tree().create_tween()
	tween.tween_property(dot, "scale", Vector2(1.5, 1.5), typing_time / 6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(dot, "scale", Vector2(1.0, 1.0), typing_time / 6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
