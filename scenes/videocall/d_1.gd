extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../images"
@onready var audio_player = $"../../Audio1"
@onready var visualNovelNode = $"../.."
var sceneName = "DEEVISUAL1"
var sceneCodeTxt = "dee_s1_txt"
var visualNovelName = "DEEVISUAL1"
var Acto = 0
var actos = {}

func _ready() -> void:
	if GlobalStats.visualNovel == visualNovelName:
		visualNovelNode.cargar_csv("res://language/Dialogos.csv", sceneName, sceneCodeTxt)
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		
		
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1
		
	elif acto_numero == 0:
		#MusicManager.music_player["parameters/switch_to_clip"] = "EXTASIS_THEME"
		#MusicManager.start_loop_for("EXTASIS_THEME")
		#audio_player.stream = load("res://sound/sounds/convert_ntr_sound_reduce.ogg")
		#audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)
