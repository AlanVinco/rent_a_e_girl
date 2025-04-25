extends CharacterBody2D

@export var speed := 50.0
@export var knockback_strength := 100.0
@export var target_position := Vector2.ZERO  # Se asigna desde el spawner (centro abajo de la pantalla)
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy: Marker2D = $Marker2D
@onready var hit_particles: CPUParticles2D = $Marker2D/CPUParticles2D

signal muerto
signal robar

var is_knocked_back := false
var knockback_timer := 0.2
var knockback_velocity := Vector2.ZERO
var knockback_elapsed := 0.0

@export var life = 50

func _physics_process(delta):
	if is_knocked_back:
		knockback_elapsed += delta
		if knockback_elapsed >= knockback_timer:
			is_knocked_back = false
			knockback_elapsed = 0.0
		else:
			velocity = knockback_velocity
	else:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed

	move_and_slide()

	## Revisar si ya llegó al cofre (cerca del target)
	#if global_position.distance_to(target_position) < 10:
		#queue_free()


func on_hit_by_sword(from_position: Vector2, damage):
	life -= damage
	hit_particles.rotation = get_angle_to(from_position) + PI
	$Marker2D/CPUParticles2D.emitting = true
	animation_player.play("hit_enemy")
	is_knocked_back = true
	knockback_elapsed = 0.0
	knockback_velocity = Vector2(0, -1) * knockback_strength
	
	if life <=0:
		_die()

# Dentro del enemigo:
func _die():
	muerto.emit(position)  # Esto dispara _on_enemy_killed en el spawner
	queue_free()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "chest":
		robar.emit(position)
		queue_free()
