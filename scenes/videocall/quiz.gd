extends CanvasLayer

@onready var question_label = $question_label
@onready var answers_container = $answers_container
@onready var language_button = $Control/change_language_button

var current_language := "esp"  # Puede ser "es" o "en"
var current_question_index := 0

signal answerSelected

var indexImage = 0

# Preguntas en español e inglés
var questions = [
	{
		"esp": {
			"question": "¿Cuál es la capital de Francia?",
			"answers": ["Madrid", "París", "Berlín", "Lisboa"],
			"correct": 1
		},
		"en": {
			"question": "What is the capital of France?",
			"answers": ["Madrid", "Paris", "Berlin", "Lisbon"],
			"correct": 1
		}
	},
	{
		"esp": {
			"question": "¿Qué lenguaje se usa en Godot?",
			"answers": ["Java", "C#", "Python", "GDScript"],
			"correct": 3
		},
		"en": {
			"question": "What language is used in Godot?",
			"answers": ["Java", "C#", "Python", "GDScript"],
			"correct": 3
		}
	}
]

func _ready() -> void:
	pass

func start_quiz():
	update_ui()
	#language_button.text = "Cambiar a Inglés"
	#language_button.pressed.connect(_on_change_language_pressed)

	for i in answers_container.get_child_count():
		var button = answers_container.get_child(i)
		button.pressed.connect(_on_answer_selected.bind(i))

func update_ui():
	var question_data = questions[current_question_index][current_language]
	question_label.text = question_data["question"]

	for i in answers_container.get_child_count():
		var button = answers_container.get_child(i)
		button.text = question_data["answers"][i]

func _on_answer_selected(index):
	var correct_index = questions[current_question_index][current_language]["correct"]
	if index == correct_index:
		print("¡Respuesta correcta!")
		indexImage += 1
		emit_signal("answerSelected")
	else:
		print("Respuesta incorrecta.")
		if indexImage  != 0:
			indexImage -= 1
		emit_signal("answerSelected")

	current_question_index += 1
	if current_question_index >= questions.size():
		#question_label.text = current_language == "es" and "¡Fin del quiz!" or "Quiz finished!"
		for button in answers_container.get_children():
			button.disabled = true
	else:
		update_ui()

func _on_change_language_pressed():
	pass
	#current_language = current_language == "es" and "en" or "es"
	#language_button.text = current_language == "es" and "Cambiar a Inglés" or "Switch to Spanish"
	#update_ui()
