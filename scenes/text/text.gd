extends Node2D

var player_node: Node = null
signal on_all_texts_displayed
signal text_end
var actos = {}
var sumando = 1
@export var sceneName = ""
@export var sceneCodeTxt = ""
var Acto = 1

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
	#player_node.move = false
	emit_signal("on_all_texts_displayed")
	load_all_text_displayed(sceneName, sceneCodeTxt, Acto, actos)

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
		#print(columnas)
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

		#print("✅ Procesado:", clave_texto, "Personaje:", personaje, "Emoción:", emocion, "Imagen:", image)

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

func transformar_actos(actos):
	var new_actos = {}
	var current_index = 1
	var last_personaje = null
	var last_emocion = null
	var last_image = null
	var textos_grupo = []
	
	for key in actos.keys():
		var entry = actos[key]
		var personaje = entry["personaje"]
		var emocion = entry["emocion"]
		var image = entry["image"]
		var texto = entry["textos"][0]
		
		# Si es el mismo personaje y emoción, agrupamos los textos
		if personaje == last_personaje and emocion == last_emocion:
			textos_grupo.append(texto)
		else:
			# Si cambia de personaje o emoción, guardamos el grupo anterior
			if textos_grupo.size() > 0:
				new_actos[current_index] = {
					"textos": textos_grupo,
					"image": last_image,
					"personaje": last_personaje,
					"emocion": last_emocion
				}
				current_index += 1
			
			# Iniciamos un nuevo grupo
			textos_grupo = [texto]
			last_personaje = personaje
			last_emocion = emocion
			last_image = image
	
	# Guardar el último grupo si hay textos pendientes
	if textos_grupo.size() > 0:
		new_actos[current_index] = {
			"textos": textos_grupo,
			"image": last_image,
			"personaje": last_personaje,
			"emocion": last_emocion
		}

	return new_actos

func load_all_text_displayed(sceneName, sceneCodeTxt, Acto, actos):
	cargar_csv("res://language/Dialogos.csv", sceneName, sceneCodeTxt)
	actos = actos
	var new_actos = transformar_actos(actos)
	actos = new_actos
	mostrar_acto(Acto, actos,)
	
func mostrar_acto(acto_numero, actos,):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + sumando
	else:
		#player_node.move = true
		re_start_dialogs()
		text_end.emit()
		
func re_start_dialogs():
	actos = {}
	Acto = 1
	sumando = 1

func set_player_reference(player):
	pass
	#player_node = player
