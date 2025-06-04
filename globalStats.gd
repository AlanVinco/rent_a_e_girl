extends Node2D

signal stats_changed
signal money_changed

# Variables con setters
@export var deePoints: int = 100:
	set(value):
		deePoints = value
		emit_signal("stats_changed")
		
@export var mekariPoints: int = 100:
	set(value):
		mekariPoints = value
		emit_signal("stats_changed")
		
@export var miaPoints: int = 100:
	set(value):
		miaPoints = value
		emit_signal("stats_changed")

@export var money: int = 100:
	set(value):
		money = value
		emit_signal("money_changed")
		AudioManager.sound.stream = load("res://audio/sound/money_sound.ogg")
		AudioManager.sound.play()
		#emit_signal("stat_changed", "life", value)

@export var egirl := "Dee"

@export var unlocked_scenes := {"Dee": [], "Mekari": [], "Mia": []}

@export var chatNameScene := "dee_1":
	set(value):
		chatNameScene = value
		if value not in unlocked_scenes[egirl]:  # Verifica si no está ya
			unlocked_scenes[egirl].append(value)  # 👈 CORRECTO
		print(unlocked_scenes)

@export var visualNovel = "":
	set(value):
		visualNovel = value
		if value not in unlocked_visual_novel:  # Verifica si el valor ya existe
			unlocked_visual_novel.append(value)  # Solo agrega si no está en la lista
		print(unlocked_visual_novel)

@export var unlocked_visual_novel = []

@export var selfie_image = ""

@export var selfies: = {"Dee": ["res://asset/icons/dee_icon_circle.png", "res://asset/icons/avatar_circle_test.png"], "Mekari": [], "Mia": []}

@export var unlocked_images := {"Dee": [], "Mekari": [], "Mia": []}

@export var dee_chating = false
@export var mekari_chating = false
@export var mia_chating = false

var loading_screen_instance: CanvasLayer = null

func change_scene_async(scene_path: String) -> void:
	# Instancia la pantalla de loading si no existe
	if not loading_screen_instance:
		var loading_scene = load("res://scenes/loading.tscn")
		loading_screen_instance = loading_scene.instantiate()
		get_tree().current_scene.add_child(loading_screen_instance)
	
	# Mostrar el loading
	loading_screen_instance.show_loading()
	
	# Pequeño retraso para que se vea el loading
	await get_tree().create_timer(0.5).timeout

	# Empieza a cargar la escena en segundo plano
	ResourceLoader.load_threaded_request(scene_path)

	while true:
		var load_state = ResourceLoader.load_threaded_get_status(scene_path)
		if load_state == ResourceLoader.THREAD_LOAD_LOADED:
			break
		await get_tree().process_frame  # Espera al siguiente frame

	# Una vez cargada, obtenemos la escena
	var packed_scene = ResourceLoader.load_threaded_get(scene_path)

	if packed_scene:
		
		# Esconde el loading
		await loading_screen_instance.hide_loading()
		
		# Cambiar de escena
		get_tree().change_scene_to_packed(packed_scene)
	else:
		push_error("No se pudo cargar la escena: " + scene_path)

func pick_selfie_image():
	# Todas las imágenes posibles de esa egirl
	var available_selfies = selfies.get(egirl, [])
	if available_selfies.is_empty():
		print("No hay selfies disponibles para ", egirl)
		return

	# Las imágenes ya desbloqueadas de esa egirl
	var unlocked = unlocked_images.get(egirl, [])

	# Filtrar las selfies que aún no han sido desbloqueadas
	var remaining = []
	for image in available_selfies:
		if image not in unlocked:
			remaining.append(image)

	# Si ya desbloqueó todas, permitir repetir
	if remaining.is_empty():
		# Todas las imágenes ya fueron desbloqueadas, ahora sí puede repetir
		selfie_image = available_selfies.pick_random()
	else:
		# Todavía quedan imágenes nuevas por desbloquear
		selfie_image = remaining.pick_random()
		unlocked_images[egirl].append(selfie_image)

	#print("Selfie seleccionada: ", selfie_image)
	#print("Unlocked images: ", unlocked_images)
