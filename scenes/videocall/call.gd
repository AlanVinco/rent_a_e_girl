extends Node

#TEXTO

signal on_all_texts_displayed
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
