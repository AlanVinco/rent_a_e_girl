extends Control

signal dialogue_finished

@onready var sidebar := $SideBar
@onready var toggle_button := $SideBar/Button
@onready var tween: Tween
@onready var profile = $Profile
@onready var chat_container: VBoxContainer = $SideBar/ChatMessages/VScrollBar/ChatContainer
@onready var CHATusername = $SideBar/Username
@onready var chat_button: Button = $SideBar/ChatButton
@onready var sounds: AudioStreamPlayer = $Sounds

#dialogue
@onready var dialogue_manager = $SideBar/DialogueManager
@onready var typing_bubble: Control = $SideBar/TypingBubble
@onready var options_container = $SideBar/OptionsContainer

@onready var chat_messages: Panel = $SideBar/ChatMessages
@onready var avatar_image: TextureRect = $SideBar/AvatarImage

var is_open := true
var collapsed_width := 100  # Solo íconos
var expanded_width := 0     # Se calcula con el tamaño de la ventana
var animation_duration := 0.3

@export var sceneName = "start"

#SIDEBAR
@export var boolChatUsername = true

func _ready():
	AudioManager.stop_music()
	toggle_button.text = "X"
	start_chat(sceneName)

	# Conecta el botón de toggle de cerrar y abrir
	toggle_button.pressed.connect(_toggle_sidebar)

##SIDE BAR
func _toggle_sidebar():
	is_open = !is_open

	if tween and tween.is_running():
		tween.kill()

	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	if is_open:
		# Expandir a todo el ancho de la ventana
		expanded_width = get_viewport_rect().size.x
		tween.tween_property(sidebar, "size:x", expanded_width, animation_duration)
		toggle_button.text = "X"
	else:
		# Volver a mostrar solo los íconos
		tween.tween_property(sidebar, "size:x", collapsed_width, animation_duration)
		toggle_button.text = "→"
		
	hide_sidebar_ements(is_open)

func hide_sidebar_ements(value):
	chat_messages.visible = value
	chat_button.visible = value
	CHATusername.visible = value
	options_container.visible = value
	avatar_image.visible = value
	boolChatUsername = value
	
##CHAT
func create_bubble_player_text(dialogue):
	var buble_text_scene = preload("res://scenes/website/bubble_player_text.tscn")
	var text_instantiate = buble_text_scene.instantiate()
	text_instantiate.global_position = position
	text_instantiate.text = dialogue
	chat_container.add_child(text_instantiate)
	 # Crear e instanciar el TextureRect para evitar bug
	var texture_rect = TextureRect.new()
	#texture_rect.texture = preload("res://path/to/your/texture.png")  # Ajusta la ruta
	chat_container.add_child(texture_rect)
	# Configura posición, tamaño, etc.
func create_bubble_text(dialogue):
	var buble_text_scene = preload("res://scenes/website/bubble_text.tscn")
	var text_instantiate = buble_text_scene.instantiate()
	text_instantiate.global_position = position
	text_instantiate.text = dialogue
	chat_container.add_child(text_instantiate)
	 # Crear e instanciar el TextureRect para evitar bug
	var texture_rect = TextureRect.new()
	#texture_rect.texture = preload("res://path/to/your/texture.png")  # Ajusta la ruta
	chat_container.add_child(texture_rect)
	# Configura posición, tamaño, etc.
func create_bubble_image(image):
	var buble_text_scene = preload("res://scenes/website/image_dialogue.tscn")
	var image_instantiate = buble_text_scene.instantiate()
	image_instantiate.global_position = position
	image_instantiate.image = image
	chat_container.add_child(image_instantiate)

func show_dialogue():
	for child in options_container.get_children():
		child.queue_free()

	var data = dialogue_manager.get_current_dialogue()

	if data:
		var idioma = dialogue_manager.idioma
		var mensajes: Array = data.get(idioma, [])
		var tiempo = float(data.get("tiempo_typing", "1.5"))

		CHATusername.visible = false

		for mensaje in mensajes:
			typing_bubble.play_typing(tiempo)
			await get_tree().create_timer(tiempo).timeout
			typing_bubble.stop_typing()
			if mensaje.is_valid_float():
				create_bubble_image(mensaje)
			else:
				create_bubble_text(mensaje)

		CHATusername.visible = boolChatUsername

		var respuestas = data.get("respuestas_%s" % idioma, [])
		for i in respuestas.size():
			var btn = Button.new()
			btn.text = respuestas[i]
			btn.pressed.connect(on_option_selected.bind(i))
			options_container.add_child(btn)


	else:
		end_chat()
		#print("❌ No se encontró el diálogo para ID:", dialogue_manager.current_id)

func on_option_selected(index: int):
	sounds.stream = load("res://audio/sound/chose_answer_sound.ogg")
	sounds.play()
	options_container.visible = false

	var data = dialogue_manager.get_current_dialogue()

	# 1. Obtener el texto de la respuesta seleccionada
	var idioma = dialogue_manager.idioma
	var respuestas = data.get("respuestas_%s" % idioma, [])
	var respuesta_texto = respuestas[index]

	# 2. Mostrar la burbuja del jugador
	create_bubble_player_text(respuesta_texto)

	# 3. Aplicar efecto y continuar diálogo
	var efecto = data["efectos"][index]
	apply_effect(efecto)
	dialogue_manager.select_option(index)
	show_dialogue()


func apply_effect(efecto: String):
	print("Efecto aplicado:", efecto)


func _on_chat_button_pressed() -> void:
	sounds.stream = load("res://audio/sound/send_answer_sound.ogg")
	sounds.play()
	options_container.visible = true

##START CHAT DIALOGUE:
func start_chat(sceneName):
	dialogue_manager.current_id = sceneName
	show_dialogue()

func end_chat():
	emit_signal("dialogue_finished")
	chat_button.disabled = true

#CLICK IMAGE 

func _on_dee_picture_gui_input(event: InputEvent) -> void:
	if event.is_action("left_click"):
		ShowImage.get_path_by_rect($HBoxContainer/Card/DeePicture)
	
func _on_mekari_image_1_gui_input(event: InputEvent) -> void:
	if event.is_action("left_click"):
		ShowImage.get_path_by_rect($HBoxContainer/Card2/MekariImage1)
		
func _on_idol_avatar_gui_input(event: InputEvent) -> void:
	if event.is_action("left_click"):
		ShowImage.get_path_by_rect($HBoxContainer/Card3/IdolAvatar)
##BUTTON PROFILE
func _on_play_dee_pressed() -> void:
	profile.username = "Dee"
	profile.load_profile()
	
func _on_play_mekari_pressed() -> void:
	profile.username = "Mekari"
	profile.load_profile()
	
func _on_play_mia_pressed() -> void:
	profile.username = "Mia"
	profile.load_profile()
	
func _on_close_pressed() -> void:
	GlobalStats.change_scene_async("res://scenes/desktop/desktop.tscn")
