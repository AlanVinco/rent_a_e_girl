extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../images"
@onready var audio_player = $"../../audioPlayer"
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
		visualNovelNode.next_animation.connect(next_anima)
		visualNovelNode.previus_animation.connect(previus_anima)
		quizNode.lost.connect(lost_the_game)

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
			
	if acto_numero == 16 and sceneName == "DEEVISUAL2":
		start_animation(true)
		
	if acto_numero == 4 and sceneName == "DEEVISUAL3" or acto_numero == 7 and sceneName == "DEEVISUAL4":
		audio_player.stream = load("res://audio/sound/VOICES/BYEBYE.ogg")
		audio_player.play()
		
	if acto_numero == 5 and sceneName == "DEEVISUAL3" or acto_numero == 8 and sceneName == "DEEVISUAL4":
		GlobalStats.change_scene_async("res://scenes/desktop/desktop.tscn")
		
	if acto_numero == 8 and sceneName == "DEEVISUAL2" or acto_numero == 11 and sceneName == "DEEVISUAL2":
		audio_player.stream = load("res://audio/sound/VOICES/open_va.ogg")
		audio_player.play()
		
	elif acto_numero == 0:
		#MusicManager.music_player["parameters/switch_to_clip"] = "EXTASIS_THEME"
		#MusicManager.start_loop_for("EXTASIS_THEME")
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
	visualNovelNode.actos = {}
	sceneName = "DEEVISUAL2"
	visualNovelNode.cargar_csv("res://language/Dialogos.csv", sceneName, "dee_s2_txt")
	actos = visualNovelNode.actos
	visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
	Acto = 1
	mostrar_acto(Acto, actos)

func random_music(music_paths, audio):
	var random_index = randi() % music_paths.size()
	var random_path = music_paths[random_index]
			
			# Cargar el sonido aleatorio en $slime
	audio.stream = load(random_path)
			
			# Reproducir el sonido
	audio.play()


func _on_animation_frame_changed() -> void:
	# Array con las rutas de los sonidos
	var slap_paths = [
		"res://audio/sound/NEWSOUNDS/GOLPE1.ogg",
		"res://audio/sound/NEWSOUNDS/GOLPE2.ogg",
		"res://audio/sound/NEWSOUNDS/GOLPE3.ogg",
		"res://audio/sound/NEWSOUNDS/GOLPE4.ogg",
		"res://audio/sound/NEWSOUNDS/GOLPE5.ogg",
	]
	var bed_paths = [
		"res://audio/sound/NEWSOUNDS/RECHINA1.ogg",
		"res://audio/sound/NEWSOUNDS/RECHINA2.ogg",
		"res://audio/sound/NEWSOUNDS/RECHINA3.ogg",
		"res://audio/sound/NEWSOUNDS/RECHINA4.ogg",
		"res://audio/sound/NEWSOUNDS/RECHINA5.ogg",
		"res://audio/sound/NEWSOUNDS/RECHINA6.ogg",
	]
	var slime_paths = [
		"res://audio/sound/NEWSOUNDS/AGUA1.ogg",
		"res://audio/sound/NEWSOUNDS/AGUA2.ogg",
		"res://audio/sound/NEWSOUNDS/AGUA3.ogg",
		"res://audio/sound/NEWSOUNDS/AGUA4.ogg",
		"res://audio/sound/NEWSOUNDS/AGUA5.ogg",
		"res://audio/sound/NEWSOUNDS/AGUA6.ogg",
		"res://audio/sound/NEWSOUNDS/AGUA7.ogg",
	]
	var espejo_paths = [
		"res://audio/sound/NEWSOUNDS/ESPEJO1.ogg",
		"res://audio/sound/NEWSOUNDS/ESPEJO2.ogg",
		"res://audio/sound/NEWSOUNDS/ESPEJO3.ogg",
		"res://audio/sound/NEWSOUNDS/ESPEJO4.ogg",
		"res://audio/sound/NEWSOUNDS/ESPEJO5.ogg",
	]
	var splash_paths = [
		"res://audio/sound/NEWSOUNDS/SPLASH1.ogg",
		"res://audio/sound/NEWSOUNDS/SPLASH2.ogg",
		"res://audio/sound/NEWSOUNDS/SPLASH3.ogg",
		"res://audio/sound/NEWSOUNDS/SPLASH4.ogg",
		"res://audio/sound/NEWSOUNDS/SPLASH5.ogg",
		"res://audio/sound/NEWSOUNDS/SPLASH6.ogg",
	]
	
	var finger_paths = [
		"res://audio/sound/NEWSOUNDS/FINGER1.ogg",
		"res://audio/sound/NEWSOUNDS/FINGER2.ogg",
		"res://audio/sound/NEWSOUNDS/FINGER3.ogg",
		"res://audio/sound/NEWSOUNDS/FINGER4.ogg",
		"res://audio/sound/NEWSOUNDS/FINGER5.ogg",
	]
	
	if $"../../Animation".animation == "dee_scene_1":
		if $"../../Animation".frame == 4:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../images", 0.1, 15.0)
			
	if $"../../Animation".animation == "dee_scene_2":
		if $"../../Animation".frame == 5:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../images", 0.1, 18.0)
			
	if $"../../Animation".animation == "dee_scene_4":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../images", 0.1, 25.0)



func next_anima():
	if $"../../Animation".animation == "dee_scene_1":
		AudioManager.start_song("CLOSER2")
		$"../../Animation".play("dee_scene_2")
		
	elif $"../../Animation".animation == "dee_scene_2":
		$"../../Animation".play("dee_scene_3")
		$"../../loop".stream = load("res://audio/sound/VOICES/fingering.ogg")
		$"../../loop".play()
		
	elif $"../../Animation".animation == "dee_scene_3":
		AudioManager.start_song("CLOSER3")
		$"../../loop".stop()
		$"../../Animation".play("dee_scene_4")
		
	elif $"../../Animation".animation == "dee_scene_4":
		AudioManager.start_song("CLOSERFINAL")
		$"../../Animation".play("dee_squirt")
		visualNovelNode.show_btns(false)
		visualNovelNode.shake_node($"../../images", 8.0, 40.0)
		visualNovelNode.shake_node($"../../Animation", 8.0, 40.0)
		audio_player.stream = load("res://audio/sound/VOICES/DEE_CLIMAX.ogg")
		audio_player.play()
		stop_random_speed()
		await get_tree().create_timer(12.0).timeout
		finish_dialogue()
		start_animation(false)
		

func previus_anima():
	if $"../../Animation".animation == "dee_scene_4":
		AudioManager.start_song("CLOSER2")
		$"../../Animation".play("dee_scene_3")
		
	elif $"../../Animation".animation == "dee_scene_3":
		$"../../Animation".play("dee_scene_2")
		
	elif $"../../Animation".animation == "dee_scene_2":
		AudioManager.start_song("CLOSER1")
		$"../../loop".stop()
		$"../../Animation".play("dee_scene_1")

func start_animation(value:bool):
	visualNovelNode.show_btns(value)
	$"../../Animation".visible = value
	$"../../Effect".visible = value
	visualNovelNode.activate_moan = value
	if value:
		canvasImage.texture = load("res://asset/cutscenes/dee/videocall/background.png")
		$"../../Animation".play("dee_scene_1")
		AudioManager.start_song("CLOSER1")
		visualNovelNode._set_random_speed()
		$"../../Effect".play("SPEED")
	else:
		$"../../Animation".stop()

func stop_random_speed():
	visualNovelNode.activate_moan = false
	$"../../moanRandom".stop()
	$"../../Animation".stop()

func finish_dialogue():
	visualNovelNode.actos = {}
	sceneName = "DEEVISUAL3"
	visualNovelNode.cargar_csv("res://language/Dialogos.csv", sceneName, "dee_s3_txt")
	#visualNovelNode.actos = {}
	actos = visualNovelNode.actos
	Acto = 1
	mostrar_acto(Acto, actos)

func load_new_dialoge(name, code):
	visualNovelNode.actos = {}
	sceneName = name
	visualNovelNode.cargar_csv("res://language/Dialogos.csv", sceneName, code)
	#visualNovelNode.actos = {}
	actos = visualNovelNode.actos
	Acto = 1
	mostrar_acto(Acto, actos)

func lost_the_game():
	quizNode.visible = false
	load_new_dialoge("DEEVISUAL4","dee_s4_txt")
	visualNovelNode.show_btns(false)
