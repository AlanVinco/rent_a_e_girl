extends Node

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
