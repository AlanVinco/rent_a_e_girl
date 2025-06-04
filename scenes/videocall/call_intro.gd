extends Node

@onready var foto = $EgirlIcon
@onready var circulo = $Circle
@onready var egirl_name: Label = $EgirlName

var tween_foto : Tween
var tween_circulo : Tween

func _ready():
	AudioManager.start_song("VIDEOCALL_THEME")
	# Centrar pivotes
	check_egirl()
	foto.pivot_offset = foto.size / 2
	circulo.pivot_offset = circulo.size / 2
	_iniciar_animacion_llamada()
	await get_tree().create_timer(6.0).timeout
	GlobalStats.change_scene_async("res://scenes/videocall/call.tscn")

func _iniciar_animacion_llamada():
	_animar_foto()
	_animar_circulo()

func _animar_foto():
	var escala_original = foto.scale
	var escala_max = escala_original * 1.1

	tween_foto = create_tween()
	tween_foto.set_loops()

	tween_foto.tween_property(foto, "scale", escala_max, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_foto.tween_property(foto, "scale", escala_original, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _animar_circulo():
	var escala_original = circulo.scale
	var escala_max = escala_original * 2.3  # Más grande que la foto

	tween_circulo = create_tween()
	tween_circulo.set_loops()

	tween_circulo.tween_property(circulo, "scale", escala_max, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_circulo.tween_property(circulo, "scale", escala_original, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func check_egirl():
	egirl_name.text = GlobalStats.egirl
	if GlobalStats.egirl == "Dee":
		foto.texture = load("res://asset/icons/dee_icon_circle.png")
		GlobalStats.visualNovel="DEEVISUAL1"
	elif GlobalStats.egirl == "Mekari":
		foto.texture = load("res://asset/icons/mekari_icon_circle.png")
		GlobalStats.visualNovel="MEKARIVISUAL1"
	elif GlobalStats.egirl == "Mia":
		foto.texture = load("res://asset/icons/mia_icon_circle.png")
		GlobalStats.visualNovel="MIAVISUAL1"
