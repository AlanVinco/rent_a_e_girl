extends Node

#TEXTO

signal on_all_texts_displayed
signal next_animation
signal previus_animation
var actos = {}

#TEXTO
@export var TextScene: PackedScene

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func _on_all_texts_displayed():
	emit_signal("on_all_texts_displayed")

func cargar_csv(ruta, escena_filtrada, keyWord):
	var file = FileAccess.open(ruta, FileAccess.READ)
	if not file:
		print("❌ Error al abrir el archivo CSV")
		return

	var contenido = file.get_as_text().strip_edges()
	file.close()

	var lineas = contenido.split("\n", false)
	if lineas.size() <= 1:
		print("⚠ Archivo vacío o con solo encabezados")
		return

	var encabezados = []
	var data = []
	
	for i in range(lineas.size()):
		var columnas = parse_csv_line(lineas[i])  # 🔹 Nueva función para procesar CSV correctamente

		if i == 0:
			encabezados = columnas
			continue  # Saltamos la primera línea (encabezados)

		if columnas.size() != encabezados.size():
			#print("⚠ Error en la línea", i, "->", columnas)
			continue

		var fila = {}
		for j in range(encabezados.size()):
			fila[encabezados[j].strip_edges()] = columnas[j].strip_edges() if j < columnas.size() else ""

		if fila.get("escena", "") == escena_filtrada:
			data.append(fila)

	if data.is_empty():
		print("⚠ No se encontraron datos para la escena:", escena_filtrada)
		return

	var index = 1  # Contador para los actos

	for i in range(data.size()):
		var fila = data[i]
		var clave_texto = keyWord + str(i + 1)

		var personaje = fila.get("personaje", "").strip_edges()
		var emocion = fila.get("emocion", "NORMAL").strip_edges()
		var image = fila.get("image", "").strip_edges()

		print("✅ Procesado:", clave_texto, "Personaje:", personaje, "Emoción:", emocion, "Imagen:", image)

		actos[index] = {
			"textos": [clave_texto],
			"image": image,
			"personaje": personaje,
			"emocion": emocion
		}

		index += 1

func parse_csv_line(line):
	var result = []
	var current = ""
	var in_quotes = false

	for i in range(line.length()):
		var char = line[i]

		if char == "\"" and (i == 0 or line[i - 1] != "\\"):  
			in_quotes = !in_quotes  # Cambiar estado de comillas
		elif char == "," and !in_quotes:
			result.append(current.strip_edges())
			current = ""
		else:
			current += char

	if current != "":
		result.append(current.strip_edges())

	return result

#RANDOM ANIMATION

@onready var timer = $AnimationSpeed # Asegúrate de tener un Timer en la escena y asignarlo
@onready var sprite = $Animation
# Rango de velocidad de la animación
@export var min_speed: float = 0.8
@export var max_speed: float = 2.0

# Rango de tiempo entre cambios de velocidad
@export var min_time: float = 3.0
@export var max_time: float = 6.0
@export var activate_moan = false

var current_sound = null  # Variable para almacenar el sonido actual

func _set_random_speed():
	var new_speed = randf_range(min_speed, max_speed)
	sprite.speed_scale = new_speed  # Modifica la velocidad de la animación

	var new_time = randf_range(min_time, max_time)
	timer.start(new_time)  # Reinicia el timer con un tiempo aleatorio

	var new_sound = null  # Para determinar qué sonido debe reproducirse

	if activate_moan and new_speed <= 2 and new_speed > 1:
		new_sound = "res://audio/sound/VOICES/GEMIDO_FUERTE1.ogg"
	elif activate_moan and new_speed <= 1 and new_speed > 0.5:
		new_sound = "res://audio/sound/VOICES/gime_leve1.ogg"
	elif activate_moan and new_speed <= 0.5 and new_speed >= 0.8:
		new_sound = "res://audio/sound/VOICES/GEMIDNO_SUAVE3.ogg"

	# Si hay un nuevo sonido y no es el mismo que se está reproduciendo
	if new_sound and (new_sound != current_sound or !$moanRandom.playing):
		current_sound = new_sound  # Guardamos el sonido actual
		$moanRandom.stream = load(new_sound)
		$moanRandom.play()

func _on_animation_speed_timeout() -> void:
	_set_random_speed()  # Cambia la velocidad cuando el timer termine

func shake_node(target: Node, duration: float = 0.5, intensity: float = 10.0):
	if not target:
		return
	
	var original_position = target.position
	var tween := create_tween()
	var shake_times := int(duration / 0.05)

	for i in range(shake_times):
		var offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		tween.tween_property(target, "position", original_position + offset, 0.025).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(target, "position", original_position, 0.025).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Asegura que al final se restaure la posición original
	tween.tween_callback(func(): target.position = original_position)

func _ready() -> void:
	show_btns(false)
func show_btns(value:bool):
	$AnimationButtons/BTNnext.visible = value
	$AnimationButtons/BTNback.visible = value

#func _ready() -> void:
	#show_btns(false)

func _on_bt_nnext_pressed() -> void:
	next_animation.emit()
	
func _on_bt_nback_pressed() -> void:
	previus_animation.emit()

func _on_button_call_icon_pressed() -> void:
	GlobalStats.change_scene_async("res://scenes/desktop/desktop.tscn")
