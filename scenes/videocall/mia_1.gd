extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../images"
@onready var audio_player = $"../../audioPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "MIAVISUAL1"
var sceneCodeTxt = "mia_s1_txt"
var visualNovelName = "MIAVISUAL1"
var Acto = 0
var actos = {}
@onready var quizNode = $"../../QUIZ"
var tween = create_tween()
var questions = [
	{
		"esp": {
			"question": "¿Cuál es el verdadero nombre de L en Death Note?",
			"answers": ["Light Yagami", "L Lawliet", "Ryuk", "Near"],
			"correct": 1
		},
		"en": {
			"question": "What is L's real name in Death Note?",
			"answers": ["Light Yagami", "L Lawliet", "Ryuk", "Near"],
			"correct": 1
		}
	},
	{
		"esp": {
			"question": "¿Quién es el creador de 'One Piece'?",
			"answers": ["Masashi Kishimoto", "Tite Kubo", "Eiichiro Oda", "Akira Toriyama"],
			"correct": 2
		},
		"en": {
			"question": "Who is the creator of 'One Piece'?",
			"answers": ["Masashi Kishimoto", "Tite Kubo", "Eiichiro Oda", "Akira Toriyama"],
			"correct": 2
		}
	},
	{
		"esp": {
			"question": "¿En qué anime aparece el personaje 'Levi Ackerman'?",
			"answers": ["Naruto", "Bleach", "Attack on Titan", "One Piece"],
			"correct": 2
		},
		"en": {
			"question": "In which anime does 'Levi Ackerman' appear?",
			"answers": ["Naruto", "Bleach", "Attack on Titan", "One Piece"],
			"correct": 2
		}
	},
	{
		"esp": {
			"question": "¿Qué es un 'Shinigami' en el contexto del anime?",
			"answers": ["Un dios de la muerte", "Un espíritu protector", "Un guerrero", "Un monstruo"],
			"correct": 0
		},
		"en": {
			"question": "What is a 'Shinigami' in anime context?",
			"answers": ["A god of death", "A protective spirit", "A warrior", "A monster"],
			"correct": 0
		}
	},
	{
		"esp": {
			"question": "¿Cómo se llama el zorro de nueve colas en Naruto?",
			"answers": ["Kurama", "Inari", "Kyubi", "Shukaku"],
			"correct": 0
		},
		"en": {
			"question": "What is the name of the nine-tailed fox in Naruto?",
			"answers": ["Kurama", "Inari", "Kyubi", "Shukaku"],
			"correct": 0
		}
	},
	{
		"esp": {
			"question": "¿Qué anime popular tiene a un protagonista llamado 'Tanjiro Kamado'?",
			"answers": ["Demon Slayer", "My Hero Academia", "Bleach", "Fullmetal Alchemist"],
			"correct": 0
		},
		"en": {
			"question": "Which popular anime features a protagonist named 'Tanjiro Kamado'?",
			"answers": ["Demon Slayer", "My Hero Academia", "Bleach", "Fullmetal Alchemist"],
			"correct": 0
		}
	},
	{
		"esp": {
			"question": "¿Cuál es el nombre del instituto donde estudia Goku en Dragon Ball?",
			"answers": ["Escuela Capsule", "Escuela Kame", "No fue a la escuela", "Escuela Red Ribbon"],
			"correct": 2
		},
		"en": {
			"question": "What is the name of the school Goku attends in Dragon Ball?",
			"answers": ["Capsule School", "Kame School", "He never went to school", "Red Ribbon School"],
			"correct": 2
		}
	},
	{
		"esp": {
			"question": "¿Qué anime es famoso por tener batallas de cocina?",
			"answers": ["Shokugeki no Soma", "One Piece", "Tokyo Ghoul", "Naruto"],
			"correct": 0
		},
		"en": {
			"question": "Which anime is famous for cooking battles?",
			"answers": ["Shokugeki no Soma", "One Piece", "Tokyo Ghoul", "Naruto"],
			"correct": 0
		}
	}
]



func _ready() -> void:
	if GlobalStats.visualNovel == visualNovelName:
		AudioManager.start_song("MIA_THEME")
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
		
	if acto_numero == 12 and sceneName == "MIAVISUAL1" or acto_numero == 5 and sceneName == "MIAVISUAL2" or acto_numero == 10 and sceneName == "MIAVISUAL3" or acto_numero == 9 and sceneName == "MIAVISUAL4" or acto_numero == 12 and sceneName == "MIAVISUAL5":
		$"../../slap".stream = load("res://audio/sound/door_knoc_and_ooen.mp3")
		$"../../slap".play()
			
	if acto_numero == 17 and sceneName == "MIAVISUAL1":
		canvasImage.visible = false
		AudioManager.start_song("CLOSER1")
		start_animation(true, "mia_scene_1")
		visualNovelNode.activate_moan = false
		$"../../moanRandom".stop()
		
	if acto_numero == 10 and sceneName == "MIAVISUAL2":
		AudioManager.start_song("CLOSER2")
		canvasImage.visible = false
		start_animation(true, "mia_scene_2")
		visualNovelNode.activate_moan = false
		$"../../moanRandom".stop()
		
	if acto_numero == 15 and sceneName == "MIAVISUAL3":
		AudioManager.start_song("CLOSER2")
		canvasImage.visible = false
		start_animation(true, "mia_scene_3")
		visualNovelNode.activate_moan = false
		$"../../moanRandom".stop()
		
	if acto_numero == 14 and sceneName == "MIAVISUAL4":
		AudioManager.start_song("CLOSER3")
		canvasImage.visible = false
		start_animation(true, "mia_scene_4")
		
	if acto_numero == 21 and sceneName == "MIAVISUAL5":
		AudioManager.start_song("CLOSER3")
		canvasImage.visible = false
		start_animation(true, "mia_scene_5")
		
		
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
	print(quizNode.indexImage)
	match quizNode.indexImage:
		0:
			canvasImage.texture = load("res://asset/cutscenes/mekari/videocall/S1.png")
		1:
			canvasImage.texture = load("res://asset/cutscenes/mekari/videocall/S2.png")
		2:
			canvasImage.texture = load("res://asset/cutscenes/mekari/videocall/S3.png")
		3:
			canvasImage.texture = load("res://asset/cutscenes/mekari/videocall/S4.png")
		4:
			quizNode.queue_free()
			canvasImage.texture = load("res://asset/cutscenes/mekari/videocall/S5.png")
			win_quiz()
	
	# Creamos otro tween para aparecer (fade in)
	var tween = create_tween()
	tween.tween_property(canvasImage, "modulate:a", 1.0, 0.3)
	
func win_quiz():
	visualNovelNode.actos = {}
	sceneName = "MEKARIVISUAL2"
	visualNovelNode.cargar_csv("res://language/Dialogos.csv", sceneName, "mekari_s2_txt")
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
	
	var kiss_paths = [
		"res://audio/sound/NEWSOUNDS/kiss1.ogg",
		"res://audio/sound/NEWSOUNDS/kiss2.ogg",
		"res://audio/sound/NEWSOUNDS/kiss3.ogg",
		"res://audio/sound/NEWSOUNDS/kiss4.ogg",
		"res://audio/sound/NEWSOUNDS/kiss5.ogg",
		"res://audio/sound/NEWSOUNDS/kiss6.ogg",
		"res://audio/sound/NEWSOUNDS/kiss7.ogg",
	]
	
	var blow_paths = [
		"res://audio/sound/NEWSOUNDS/blow1.ogg",
		"res://audio/sound/NEWSOUNDS/blow2.ogg",
		"res://audio/sound/NEWSOUNDS/blow3.ogg",
		"res://audio/sound/NEWSOUNDS/blow4.ogg",
		"res://audio/sound/NEWSOUNDS/blow5.ogg",
		"res://audio/sound/NEWSOUNDS/blow6.ogg",
		"res://audio/sound/NEWSOUNDS/blow7.ogg",
		"res://audio/sound/NEWSOUNDS/blow8.ogg",
	]
	
	var succion_paths = [
		"res://audio/sound/NEWSOUNDS/succion1.ogg",
		"res://audio/sound/NEWSOUNDS/succion2.ogg",
		"res://audio/sound/NEWSOUNDS/succion3.ogg",
		"res://audio/sound/NEWSOUNDS/succion4.ogg",
		"res://audio/sound/NEWSOUNDS/succion5.ogg",
	]
	
			
	if $"../../Animation".animation == "mia_scene_1":
		if $"../../Animation".frame == 3:
			random_music(kiss_paths, $"../../slap")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../Animation", 0.1, 10.0)
			
	if $"../../Animation".animation == "mia_scene_2":
		if $"../../Animation".frame == 2:
			random_music(blow_paths, $"../../slap")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../Animation", 0.1, 30.0)
			
	if $"../../Animation".animation == "mia_scene_3":
		if $"../../Animation".frame == 4:
			random_music(finger_paths, $"../../slap")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../Animation", 0.1, 20.0)
			
	if $"../../Animation".animation == "mia_scene_4":
		if $"../../Animation".frame == 1:
			# Si tu nodo se llama canvasLayer, lo llamas así:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../Animation", 0.1, 60.0)
			
	if $"../../Animation".animation == "mia_scene_5":
		if $"../../Animation".frame == 3:
			# Si tu nodo se llama canvasLayer, lo llamas así:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../Animation", 0.1, 60.0)

func next_anima():
		
	if $"../../Animation".animation == "mia_scene_1":
		$"../../Animation".play("mia_scene_1_cum")
		visualNovelNode.show_btns(false)
		visualNovelNode.shake_node($"../../images", 5.0, 40.0)
		visualNovelNode.shake_node($"../../Animation", 5.0, 40.0)
		audio_player.stream = load("res://audio/sound/NEWSOUNDS/MIA_CUM1.ogg")
		audio_player.play()
		stop_random_speed()
		await get_tree().create_timer(6.0).timeout
		AudioManager.start_song("MIA_THEME")
		canvasImage.visible = true
		load_new_dialoge("MIAVISUAL2", "mia_s2_txt")
		start_animation(false, "mia_scene_1_cum")
		
	if $"../../Animation".animation == "mia_scene_2":
		$"../../Animation".play("mia_scene_2_cum")
		visualNovelNode.show_btns(false)
		visualNovelNode.shake_node($"../../images", 9.0, 40.0)
		visualNovelNode.shake_node($"../../Animation", 9.0, 40.0)
		audio_player.stream = load("res://audio/sound/VOICES/cum_mouth_tocer.ogg")
		audio_player.play()
		stop_random_speed()
		await get_tree().create_timer(11.0).timeout
		AudioManager.start_song("MIA_THEME")
		canvasImage.visible = true
		load_new_dialoge("MIAVISUAL3", "mia_s3_txt")
		start_animation(false, "mia_scene_2_cum")
		
	if $"../../Animation".animation == "mia_scene_3":
		$"../../Animation".play("mia_scene_3_cum")
		visualNovelNode.show_btns(false)
		visualNovelNode.shake_node($"../../images", 5.0, 40.0)
		visualNovelNode.shake_node($"../../Animation", 5.0, 40.0)
		audio_player.stream = load("res://audio/sound/NEWSOUNDS/MIA_CUM3.ogg")
		audio_player.play()
		stop_random_speed()
		await get_tree().create_timer(7.0).timeout
		AudioManager.start_song("MIA_THEME")
		canvasImage.visible = true
		load_new_dialoge("MIAVISUAL4", "mia_s4_txt")
		start_animation(false, "mia_scene_3_cum")
		
	if $"../../Animation".animation == "mia_scene_4":
		visualNovelNode.activate_moan = false
		$"../../moanRandom".stop()
		$"../../Animation".play("mia_scene_4_cum")
		visualNovelNode.show_btns(false)
		visualNovelNode.shake_node($"../../images", 6.0, 40.0)
		visualNovelNode.shake_node($"../../Animation", 6.0, 40.0)
		audio_player.stream = load("res://audio/sound/NEWSOUNDS/CUM_MIA_4.ogg")
		audio_player.play()
		stop_random_speed()
		await get_tree().create_timer(8.0).timeout
		AudioManager.start_song("MIA_THEME")
		canvasImage.visible = true
		load_new_dialoge("MIAVISUAL5", "mia_s5_txt")
		start_animation(false, "mia_scene_4_cum")
		
	if $"../../Animation".animation == "mia_scene_5":
		AudioManager.start_song("CLOSERFINAL")
		visualNovelNode.activate_moan = false
		$"../../moanRandom".stop()
		$"../../Animation".play("mia_scene_5_cum")
		visualNovelNode.show_btns(false)
		visualNovelNode.shake_node($"../../images", 10.0, 40.0)
		visualNovelNode.shake_node($"../../Animation", 10.0, 40.0)
		audio_player.stream = load("res://audio/sound/NEWSOUNDS/MIA_CUM_5.ogg")
		audio_player.play()
		stop_random_speed()
		await get_tree().create_timer(23.0).timeout
		GlobalStats.change_scene_async("res://scenes/desktop/desktop.tscn")
		

func previus_anima():
	pass


func start_animation(value:bool, name):
	visualNovelNode.show_btns(value)
	$"../../Animation".visible = value
	$"../../Effect".visible = value
	visualNovelNode.activate_moan = value
	if value:
		canvasImage.texture = load("res://asset/cutscenes/mia/black.png")
		$"../../Animation".play(name)
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
