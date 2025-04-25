extends Control

@onready var bot_label = $Label
@onready var options_container = $VBoxContainer
@onready var dialogue_manager = $DialogueManager

@onready var typing_bubble: Control = $TypingBubble

func _ready():
	show_dialogue()

func show_dialogue():
	for child in options_container.get_children():
		child.queue_free()

	var data = dialogue_manager.get_current_dialogue()
	#print("Datos cargados:", data)  # ← Agrega esta línea

	if data:
		var idioma = dialogue_manager.idioma
		var texto = data.get(idioma, "???")
		var tiempo = float(data.get("tiempo_typing", "1.5"))

		typing_bubble.play_typing(tiempo)
		await get_tree().create_timer(tiempo).timeout
		typing_bubble.stop_typing()

		bot_label.text = texto

		var respuestas = data.get("respuestas_%s" % idioma, [])
		for i in respuestas.size():
			var btn = Button.new()
			btn.text = respuestas[i]
			btn.pressed.connect(on_option_selected.bind(i))
			options_container.add_child(btn)
	else:
		pass
		#print("❌ No se encontró el diálogo para ID:", dialogue_manager.current_id)

func on_option_selected(index: int):
	var data = dialogue_manager.get_current_dialogue()
	var efecto = data["efectos"][index]
	apply_effect(efecto)
	dialogue_manager.select_option(index)
	show_dialogue()

func apply_effect(efecto: String):
	print("Efecto aplicado:", efecto)
