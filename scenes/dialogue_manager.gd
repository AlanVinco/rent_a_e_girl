extends Node
class_name DialogueManager

var dialogues = {}
@export var current_id = "start"
var idioma: String = "esp"  # Idioma por defecto

func _ready():
	load_csv("res://language/Dialogos.csv")

func load_csv(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	file.get_line() # Saltamos encabezado
	while not file.eof_reached():
		var line = file.get_line()
		var cols = line.split(",", false)
		if cols.size() >= 11:
			var id = cols[0]
			dialogues[id] = {
				"id": id,
				"escena": cols[1],
				"personaje": cols[2],
				"emocion": cols[3],
				"image": cols[4],
				"esp": cols[5].split("||"),
				"en": cols[6].split("||"),
				"respuestas_esp": cols[7].split("|"),
				"respuestas_en": cols[8].split("|"),
				"siguientes_ids": cols[9].split("|"),
				"efectos": cols[10].split("|")
			}
		#print("IDs cargados:")
		#for key in dialogues.keys():
			#print(" -", key)



func get_current_dialogue():
	return dialogues.get(current_id, null)

func select_option(index: int):
	var node = dialogues.get(current_id)
	if not node:
		return
	var next_id = node["siguientes_ids"][index]
	if next_id != "---":
		current_id = next_id
		print("Cambiando a siguiente escena:", current_id)
