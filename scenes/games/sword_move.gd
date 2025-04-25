extends CharacterBody2D

@export var speed : float = 300.0  # Velocidad de movimiento

func _physics_process(delta):
	# Obtener input de teclado
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Calcular movimiento
	velocity = input_direction * speed
	
	# Mover al personaje
	move_and_slide()
