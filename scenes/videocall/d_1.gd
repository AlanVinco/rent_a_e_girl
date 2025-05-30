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
@onready var quizNode = $"../../QUIZ"
var tween = create_tween()
var questions = [
	{
		"esp": {
			"question": "¿Qué personaje es la mascota oficial de Nintendo?",
			"answers": ["Sonic", "Mario", "Link", "Donkey Kong"],
			"correct": 1
		},
		"en": {
			"question": "What is the capital of France?",
			"answers": ["Madrid", "Paris", "Berlin", "Lisbon"],
			"correct": 1
		}
	},
	{
		"esp": {
			"question": "¿Cuál fue la primera consola de videojuegos doméstica de la historia?",
			"answers": ["Nintendo Entertainment System (NES)", "Atari 2600", "Magnavox Odyssey", "Sega Genesis"],
			"correct": 2
		},
		"en": {
			"question": "What language is used in Godot?",
			"answers": ["Java", "C#", "Python", "GDScript"],
			"correct": 3
		}
	},
		{
		"esp": {
			"question": "¿En qué juego apareció por primera vez el personaje de Lara Croft?",
			"answers": ["Uncharted", "Tomb Raider", "Prince of Persia", "Resident Evil"],
			"correct": 1
		},
		"en": {
			"question": "What language is used in Godot?",
			"answers": ["Java", "C#", "Python", "GDScript"],
			"correct": 3
		}
	},
		{
		"esp": {
			"question": "¿Cuál es el nombre del mundo principal en “The Legend of Zelda”?",
			"answers": ["Tamriel", "Runeterra", "Azeroth", "Hyrule"],
			"correct": 3
		},
		"en": {
			"question": "What language is used in Godot?",
			"answers": ["Java", "C#", "Python", "GDScript"],
			"correct": 3
		}
	},
		{
		"esp": {
			"question": "¿Cuál de los siguientes juegos fue desarrollado por Rockstar Games?",
			"answers": ["The Witcher 3", "Grand Theft Auto V", "Halo", "Doom"],
			"correct": 1
		},
		"en": {
			"question": "What language is used in Godot?",
			"answers": ["Java", "C#", "Python", "GDScript"],
			"correct": 3
		}
	},
		{
		"esp": {
			"question": "¿Qué título fue un gran éxito de Nintendo en 2017 y recibió múltiples premios a Juego del Año?",
			"answers": ["The Legend of Zelda: Breath of the Wild", "Super Mario Odyssey", "Animal Crossing: New Horizons", "Splatoon 2"],
			"correct": 0
		},
		"en": {
			"question": "What language is used in Godot?",
			"answers": ["Java", "C#", "Python", "GDScript"],
			"correct": 3
		}
	},
		{
		"esp": {
			"question": "¿En qué saga de videojuegos luchas contra criaturas conocidas como Heartless?",
			"answers": ["Final Fantasy", "Kingdom Hearts", "Dark Souls", "Castlevania"],
			"correct": 1
		},
		"en": {
			"question": "What language is used in Godot?",
			"answers": ["Java", "C#", "Python", "GDScript"],
			"correct": 3
		}
	},
		{
		"esp": {
			"question": "¿Qué empresa desarrolló la saga de juegos “The Witcher”?",
			"answers": ["Bethesda", "Ubisoft", "Bioware", "CD Projekt Red"],
			"correct": 3
		},
		"en": {
			"question": "What language is used in Godot?",
			"answers": ["Java", "C#", "Python", "GDScript"],
			"correct": 3
		}
	},
]

func _ready() -> void:
	if GlobalStats.visualNovel == visualNovelName:
		AudioManager.start_song("DEE_THEME")
		visualNovelNode.cargar_csv("res://language/Dialogos.csv", sceneName, sceneCodeTxt)
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)
		quizNode.questions = questions
		quizNode.answerSelected.connect(change_image)

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		
		
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1
		
	if acto_numero == 5 and sceneName == "DEEVISUAL1":
			quizNode.visible = true
			quizNode.start_quiz()
		
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

func change_image():
	# Creamos un tween para desvanecer (fade out)
	var tween = create_tween()
	tween.tween_property(canvasImage, "modulate:a", 0.0, 0.3)
	tween.tween_callback(Callable(self, "_on_fade_out_done"))

func _on_fade_out_done():
	# Cambiar imagen
	match quizNode.indexImage:
		0:
			canvasImage.texture = load("res://asset/cutscenes/dee/videocall/S1.png")
		1:
			canvasImage.texture = load("res://asset/cutscenes/dee/videocall/S2.png")
		2:
			canvasImage.texture = load("res://asset/cutscenes/dee/videocall/S3.png")
		3:
			canvasImage.texture = load("res://asset/cutscenes/dee/videocall/S4.png")
		4:
			quizNode.queue_free()
			canvasImage.texture = load("res://asset/cutscenes/dee/videocall/S5.png")
			win_quiz()
	
	# Creamos otro tween para aparecer (fade in)
	var tween = create_tween()
	tween.tween_property(canvasImage, "modulate:a", 1.0, 0.3)
	
func win_quiz():
	print("gano stop game")
	sceneName = "DEEVISUAL2"
	visualNovelNode.cargar_csv("res://language/Dialogos.csv", sceneName, "dee_s2_txt")
	actos = visualNovelNode.actos
	visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
	Acto = 1
	mostrar_acto(Acto, actos)
