extends TextureRect

@onready var tween: Tween = null
var initial_rotation: float

# Configuración
var bounce_angle = 20.0 # Ángulo máximo de giro en grados
var bounce_duration = 0.4 # Duración de ida y vuelta

func _ready():
	initial_rotation = rotation
	mouse_filter = Control.MOUSE_FILTER_PASS
	# Mover el pivote al centro-arriba
	pivot_offset = Vector2(size.x / 2, 0)

func _input(event):
	if event is InputEventMouseMotion:
		if get_rect().has_point(get_local_mouse_position()):
			if not tween or not tween.is_running():
				var local_mouse_pos = get_local_mouse_position()
				var center = size / 2

				var direction = 0.0

				if local_mouse_pos.x < center.x:
					direction = -1 # Si toca izquierda, girar hacia derecha
				else:
					direction = 1 # Si toca derecha, girar hacia izquierda

				_make_pendulum_swing(direction)

func _make_pendulum_swing(direction: float):
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()

	var target_rotation = deg_to_rad(bounce_angle) * direction

	# Ir al primer ángulo (lado opuesto)
	tween.tween_property(self, "rotation", target_rotation, bounce_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Rebotar al otro lado pero con menos fuerza
	tween.tween_property(self, "rotation", -target_rotation * 0.6, bounce_duration * 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Rebotar más pequeño
	tween.tween_property(self, "rotation", target_rotation * 0.3, bounce_duration * 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Finalmente regresar al centro
	tween.tween_property(self, "rotation", initial_rotation, bounce_duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
