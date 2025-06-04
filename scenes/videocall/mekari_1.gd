extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../images"
@onready var audio_player = $"../../audioPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "MEKARIVISUAL1"
var sceneCodeTxt = "mekari_s1_txt"
var visualNovelName = "MEKARIVISUAL1"
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
		AudioManager.start_song("MEKARI_THEME")
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
		
	if acto_numero == 8 and sceneName == "MEKARIVISUAL1":
			quizNode.visible = true
			quizNode.start_quiz()
			#start_animation(true)
			
	if acto_numero == 25 and sceneName == "MEKARIVISUAL2":
		start_animation(true, "mekari_scene_1")
		
	if acto_numero == 28 and sceneName == "MEKARIVISUAL3":
		start_animation(true, "mekari_scene_2")
		visualNovelNode.activate_moan = false
		$"../../moanRandom".stop()
		
		
	if acto_numero == 5 and sceneName == "MEKARIVISUAL4":
		audio_player.stream = load("res://audio/sound/VOICES/BYEBYE.ogg")
		audio_player.play()
		
	if acto_numero == 6 and sceneName == "MEKARIVISUAL4":
		GlobalStats.change_scene_async("res://scenes/desktop/desktop.tscn")
		
	if acto_numero == 3 and sceneName == "MEKARIVISUAL3":
		$"../../slap".stream = load("res://audio/sound/door_knoc_and_ooen.mp3")
		$"../../slap".play()
		
	if acto_numero == 10 and sceneName == "MEKARIVISUAL2" or acto_numero == 14 and sceneName == "MEKARIVISUAL2" or acto_numero == 14 and sceneName == "MEKARIVISUAL2" or acto_numero == 17 and sceneName == "MEKARIVISUAL2":
		$"../../slap".stream = load("res://audio/sound/VOICES/open_va.ogg")
		$"../../slap".play()
		
	if acto_numero == 23 and sceneName == "MEKARIVISUAL3":
		$"../../slap".stream = load("res://audio/sound/bragueta_sound.mp3")
		$"../../slap".play()
		
	if acto_numero == 14 and sceneName == "MEKARIVISUAL3":
		AudioManager.start_song("EVIL_THEME")
		
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
	
	
	
			
	if $"../../Animation".animation == "mekari_scene_1":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../images", 0.1, 25.0)
	
	if $"../../Animation".animation == "mekari_scene_2":
		if $"../../Animation".frame == 5:
			random_music(kiss_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			#visualNovelNode.shake_node($"../../images", 0.1, 10.0)
			
	if $"../../Animation".animation == "mekari_scene_5":
		if $"../../Animation".frame == 2:
			random_music(blow_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../images", 0.1, 25.0)
			
	if $"../../Animation".animation == "mekari_scene_6":
		if $"../../Animation".frame == 0:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../images", 0.2, 40.0)
			
	if $"../../Animation".animation == "mekari_scene_7":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			# Si tu nodo se llama canvasLayer, lo llamas así:
			#visualNovelNode.shake_node($"../../Animation", 0.4, 8.0)
			visualNovelNode.shake_node($"../../images", 0.2, 50.0)
			
	if $"../../Animation".animation == "mekari_scene_3":
		if $"../../Animation".frame == 6:
			random_music(succion_paths, $"../../splash")
			visualNovelNode.shake_node($"../../images", 0.1, 20.0)

func next_anima():
		
	if $"../../Animation".animation == "mekari_scene_1":
		$"../../Animation".play("mekari_climax1")
		visualNovelNode.show_btns(false)
		visualNovelNode.shake_node($"../../images", 8.0, 40.0)
		visualNovelNode.shake_node($"../../Animation", 8.0, 40.0)
		audio_player.stream = load("res://audio/sound/VOICES/DEE_CLIMAX.ogg")
		audio_player.play()
		stop_random_speed()
		await get_tree().create_timer(12.0).timeout
		load_new_dialoge("MEKARIVISUAL3", "mekari_s3_txt")
		start_animation(false, "mekari_scene_1")
		
	elif $"../../Animation".animation == "mekari_scene_2":
		#AudioManager.start_song("CLOSER2")
		$"../../Animation".play("mekari_scene_3")
		$"../../loop".stream = load("res://audio/sound/VOICES/GEMIDO_LEVE1.ogg")
		$"../../loop".play()
		
	elif $"../../Animation".animation == "mekari_scene_3":
		AudioManager.start_song("CLOSER2")
		$"../../Animation".play("mekari_scene_4")
		$"../../loop2".stream = load("res://audio/sound/NEWSOUNDS/frotar.ogg")
		$"../../loop2".play()
	elif $"../../Animation".animation == "mekari_scene_4":
		$"../../loop".stop()
		$"../../loop2".stop()
		$"../../Animation".play("mekari_scene_5")
	elif $"../../Animation".animation == "mekari_scene_5":
		AudioManager.start_song("CLOSER3")
		visualNovelNode.activate_moan = true
		$"../../moanRandom".play()
		$"../../Animation".play("mekari_scene_6")
		
	elif $"../../Animation".animation == "mekari_scene_6":
		$"../../Animation".play("mekari_scene_7")
		
	elif $"../../Animation".animation == "mekari_scene_7":
		AudioManager.start_song("CLOSERFINAL")
		$"../../Animation".play("mekari_scene_end")
		visualNovelNode.show_btns(false)
		visualNovelNode.shake_node($"../../images", 13.0, 60.0)
		visualNovelNode.shake_node($"../../Animation", 13.0, 60.0)
		audio_player.stream = load("res://audio/sound/VOICES/cum_girl2.ogg")
		audio_player.play()
		stop_random_speed()
		await get_tree().create_timer(14.0).timeout
		GlobalStats.change_scene_async("res://scenes/desktop/desktop.tscn")
		

func previus_anima():
	if $"../../Animation".animation == "mekari_scene_3":
		#AudioManager.start_song("CLOSER2")
		$"../../Animation".play("mekari_scene_2")
		$"../../loop".stop()
	elif $"../../Animation".animation == "mekari_scene_4":
		AudioManager.start_song("CLOSER1")
		$"../../Animation".play("mekari_scene_3")
		$"../../loop2".stop()
	elif $"../../Animation".animation == "mekari_scene_5":
		$"../../loop".stream = load("res://audio/sound/VOICES/GEMIDO_LEVE1.ogg")
		$"../../loop".play()
		$"../../Animation".play("mekari_scene_4")
		$"../../loop2".stream = load("res://audio/sound/NEWSOUNDS/frotar.ogg")
		$"../../loop2".play()
	elif $"../../Animation".animation == "mekari_scene_6":
		AudioManager.start_song("CLOSER2")
		visualNovelNode.activate_moan = false
		$"../../moanRandom".stop()
		$"../../Animation".play("mekari_scene_5")
		
	elif $"../../Animation".animation == "mekari_scene_7":
		$"../../Animation".play("mekari_scene_6")


func start_animation(value:bool, name):
	visualNovelNode.show_btns(value)
	$"../../Animation".visible = value
	$"../../Effect".visible = value
	visualNovelNode.activate_moan = value
	if value:
		canvasImage.texture = load("res://asset/cutscenes/mekari/videocall/BACKGROUND.png")
		$"../../Animation".play(name)
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
	load_new_dialoge("MEKARIVISUAL4","mekari_s4_txt")
	visualNovelNode.show_btns(false)
