extends Node2D

@onready var sword = $Marker2D
@onready var hit_area = $Marker2D/Sword/HitArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var speed : float = 600.0  # Velocidad de movimiento
@onready var shadow: Sprite2D = $shadow
@export var damage = 10
@onready var slash_sound: AudioStreamPlayer2D = $SlashSound

var attack_cooldown := 0.2
var can_attack := true
var float_time = 0.0
var mouse_pos
var angle_deg

func _process(delta):
	# Obtener la posición del mouse en el viewport
	mouse_pos = get_viewport().get_mouse_position()

	# Cálculo base: posición objetivo de la espada
	var target_pos = mouse_pos
	target_pos.y += sin(float_time * 5.0) * 10  # Flotación vertical agregada aquí
	
	# Movimiento suave hacia el mouse con offset flotante
	sword.global_position = sword.global_position.move_toward(target_pos, speed * delta)
	
	# Rotación natural hacia el mouse
	sword.look_at(mouse_pos)
	sword.rotation = wrapf(sword.rotation, -PI, PI)  # Normaliza la rotación aquí
	shadow.position = sword.position + Vector2(0, 50)

	# Escalado para girar el sprite verticalmente
	if mouse_pos.x < global_position.x:
		sword.scale.y = -1.0
	else:
		sword.scale.y = 1.0
	
	# Actualiza la dirección del raycast
	var mouse_direction = (get_global_mouse_position() - sword.global_position).normalized()

	# Actualiza la posición y la dirección del RayCast2D
	#ray_cast_2d.position = sword.position
	#ray_cast_2d.rotation = mouse_direction.angle()  # Asegura que el raycast apunte al mouse

	# Tiempo de flotación (solo una vez por frame)
	float_time += delta

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if can_attack:
			_attack()

func _attack():
	can_attack = false
	slash_sound.stream = load("res://audio/sound/slice.mp3")

	# Reflejar visualmente la espada y reproducir la misma animación
	var normalized_rotation = wrapf(sword.rotation, -PI, PI)

	if normalized_rotation > 0:
		animation_player.play("slash_with_trail")
	else:
		animation_player.play("slash_with_trail_left")

	# Detección de golpes
	for body in hit_area.get_overlapping_bodies():
		if body.has_method("on_hit_by_sword"):
			slash_sound.stream = load("res://audio/sound/slice-blood.mp3")
			body.on_hit_by_sword(global_position, damage)

	slash_sound.pitch_scale = randf_range(1.0, 2.0)
	slash_sound.play()

	# Temporizador para el cooldown
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
