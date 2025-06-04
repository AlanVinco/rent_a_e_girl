extends MarginContainer

@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 256

var text = ""
var letter_index = 0
var talkingNode

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying()  # Se emite cuando termina un texto
signal all_texts_displayed()  # Se emite cuando todos los textos terminan

var activate_node_scale = false
var base_node_scale
# VARIABLES GLOBALES
@export var typing_speed: float = 0.05  # Velocidad del efecto de tipeo
var is_typing = false
var current_dialog_index = 0

@onready var audio_player = $AudioStreamPlayer2D  # Asegúrate de tener un nodo AudioStreamPlayer en la escena

#MOSTRAR PJ 

# Función para iniciar el efecto de tipeo
func start_typing_effect(text_array: Array, character, emotion) -> void:
	
	await get_tree().process_frame  

	var translated_texts = text_array.map(func(key):
		return TranslationManager.translate(key)
	)
	
	if character != "":
		var fullName = "CanvasLayer/"+character + emotion
		var node = get_node_or_null(fullName)
		if node:
			node.visible = true
			var tween = create_tween()
			node.position.x = 1000  
			tween.tween_property(node, "position:x", 400, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			talkingNode = node

	var label = $CanvasLayer/MarginContainer/Label
	if not label or translated_texts.is_empty():
		return

	current_dialog_index = 0
	is_typing = true
	await _show_next_dialog(label, translated_texts, character)
	
	# Cuando termine el tipeo, cambiar a la animación de respirar
	if character != "":
		var node = get_node_or_null("CanvasLayer/"+character + emotion)
		if node:
			_start_breathing_animation(node)  # 😮‍💨 Cambiar a animación de respiración
# Función privada que escribe el texto letra por letra
# Función privada que escribe el texto letra por letra
func _type_text(label: Label, full_text: String, character) -> void:
	if talkingNode:
		_start_talking_animation(talkingNode)
	var current_text = ""
	var index = 0
	is_typing = true

	while index < full_text.length():
		current_text += full_text[index]
		##COLOR
		match character:
			"DEE", "DEEVISUAL":
				label.set("theme_override_colors/font_color", Color("ff589b"))
			"MEKARI", "MEKARIVISUAL":
				label.set("theme_override_colors/font_color", Color("961fff"))
			"MIA", "MIAVISUAL":
				label.set("theme_override_colors/font_color", Color("689eff"))
			"MALO":
				label.set("theme_override_colors/font_color", Color("d39100"))
			"MESERO", "MESEROVISUAL":
				label.set("theme_override_colors/font_color", Color("ffffff"))
			"POLICE", "POLICEVISUAL":
				label.set("theme_override_colors/font_color", Color("3f83ff"))
			"ZOMBIEVISUAL":
				label.set("theme_override_colors/font_color", Color("1d9000"))
			"ANOTHERVISUAL", "ANOTHER":
				label.set("theme_override_colors/font_color", Color("cd7637"))
			
		label.text = current_text
		_play_letter_sound(character)
		index += 1
		await get_tree().create_timer(typing_speed).timeout  
	
	is_typing = false
	finished_displaying.emit()

# Función que muestra cada diálogo y espera que el usuario presione Enter
func _show_next_dialog(label: Label, text_array: Array, character) -> void:
	while current_dialog_index < text_array.size():
		var full_text = text_array[current_dialog_index]
		await _type_text(label, full_text, character)
		await _wait_for_input("ui_accept")
		current_dialog_index += 1

	all_texts_displayed.emit()
	queue_free()  # 🔥 Esto eliminará el nodo después de mostrar todo el texto
# Función que espera la entrada del usuario para continuar
func _wait_for_input(action: String) -> void:
	# Esperamos hasta que se presione la acción especificada (por ejemplo, "ui_accept")
	while not Input.is_action_just_pressed(action):
		await get_tree().create_timer(0).timeout  # Pausar hasta el siguiente frame para evitar congelamientos

# Función opcional para mostrar el texto directamente si lo necesitas
func display_text(text_to_display):
	text = text_to_display
	$CanvasLayer/MarginContainer/Label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		$CanvasLayer/MarginContainer/Label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.x -= size.y / 2
	
	$CanvasLayer/MarginContainer/Label.text = ""


func _start_talking_animation(node):
	var base_scale = node.scale
	var tween = create_tween().set_loops()  # Loops infinitos
	tween.tween_property(node, "scale", base_scale * Vector2(1.05, 0.95), 0.1)
	tween.tween_property(node, "scale", base_scale, 0.1)

	await finished_displaying  # Espera a que termine de escribir
	tween.kill()  # Detiene la animación cuando termina el tipeo
	_start_breathing_animation(node)  # Cambia a la animación de respirar

# 😮‍💨 **Animación de respirar (suave)**
func _start_breathing_animation(node):
	if activate_node_scale:
		pass
	else:
		activate_node_scale = true
		base_node_scale = node.scale  # Guardamos la escala inicial
	var tween = create_tween().set_loops()  # Loops infinitos
	while not is_typing:
		tween.tween_property(node, "scale", base_node_scale * Vector2(1.02, 0.98), 1.5)
		tween.tween_property(node, "scale", base_node_scale, 1.5)
		await get_tree().create_timer(3.0).timeout  # Pausa para hacer la respiración suave

# Función para reproducir el sonido y cambiar el tono
func _play_letter_sound(character) -> void:
	if audio_player:
		# Cambiar el tono de forma dinámica (ajusta este valor como prefieras)
		#audio_player.pitch_scale = randi_range(80, 120) / 100.0  # Cambia el tono de 0.8 a 1.2
		#audio_player.pitch_scale = 0.1 demond voice
		#audio_player.pitch_scale = 3
		if character == "RATZWEL" or character == "RATZWELOCULTO" or character == "RATZWELVISUAL":
			audio_player.pitch_scale = randi_range(80, 120) / 100.0 
		if character == "DEE" or "DEEVISUAL":
			audio_player.pitch_scale = 3
		if character == "MALO":
			audio_player.pitch_scale = 0.5
		if character == "MEKARI" or character == "MEKARIVISUAL":
			audio_player.pitch_scale = 1
		if character == "MIA" or character == "MIAVISUAL":
			audio_player.pitch_scale = 2
			#audio_player.pitch_scale = randi_range(300, 500) / 100.0
		if character == "PLAYER" or character == "PLAYERVISUAL":
			audio_player.pitch_scale = 0.8
			#audio_player.pitch_scale = randi_range(80, 100) / 100.0
		if character == "ZOMBIEVISUAL":
			audio_player.pitch_scale = 0.1
			##audio_player.pitch_scale = randi_range(80, 100) / 100.0
		if character == "VENDEDOR" or character == "VENDEDORVISUAL":
			audio_player.pitch_scale = 0.7
		if character == "MESERO" or character == "MESEROVISUAL":
			audio_player.pitch_scale = 0.5
		if character == "POLICE" or character == "POLICEVISUAL":
			audio_player.pitch_scale = 0.6
		if character == "ANOTHERVISUAL" or character == "ANOTHER":
			audio_player.pitch_scale = 0.6
			#audio_player.pitch_scale = randi_range(80, 100) / 100.0
		#if character == "TEACHER":
			#audio_player.pitch_scale = 2
		#if character == "OLVIRA":
			#audio_player.pitch_scale = 4
		#if character == "ARLETTA":
			#audio_player.pitch_scale = 5
		#if character == "OTZIRI":
			#audio_player.pitch_scale = 6
		#if character == "CHIZU":
			#audio_player.pitch_scale = 7
		#if character == "CHORIKURI":
			#audio_player.pitch_scale = 1.5
		#if character == "CHORIZU":
			#audio_player.pitch_scale = 0.9
		audio_player.play()
