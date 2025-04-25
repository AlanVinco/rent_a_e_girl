extends Node

@onready var chest = $Chest
@onready var enemy_spawner = $EnemyNPC
@onready var collision_shape = $Spawn1/CollisionShape2D
@onready var enemy_spawn_area = $EnemysNode
var enemyScene = preload("res://scenes/games/enemy_npc.tscn")
@onready var spawn_time: Timer = $SpawnTime
@onready var coinSound = $CoinSound
@onready var money_alert: Label = $Chest/MoneyAlert

var timeOleadas = 10
#cantidad de enemigos
var numberRange = 3
var rng = RandomNumberGenerator.new()

var enemy_count = 0
var max_enemies_alive = 30  # Límite de enemigos vivos

var player_money = 0

var time_elapsed = 0.0

func _process(delta):
	time_elapsed += delta
	if time_elapsed > 30:  # cada 30s aumenta dificultad
		numberRange = min(numberRange + 1, 10)
		max_enemies_alive = min(max_enemies_alive + 5, 50)
		time_elapsed = 0

func _ready():
	await get_tree().process_frame  # Espera 1 frame por seguridadnew()
	AudioManager.music_player.play()
	start_game()

func get_random_position():
	var area_rect = collision_shape.shape.get_rect()
	var x = randf_range(area_rect.position.x, area_rect.end.x)
	var y = randf_range(area_rect.position.y, area_rect.end.y)
	return $Spawn1.global_position + Vector2(x, y)

func spawn_enemy(count):
	for i in range(count):
		if enemy_count >= max_enemies_alive:
			break
		var enemy_instantiate = enemyScene.instantiate()
		enemy_instantiate.global_position = get_random_position()
		enemy_instantiate.set("target_position", chest.global_position)
		enemy_instantiate.speed = randf_range(50.0, 200.0)
		enemy_instantiate.connect("muerto", Callable(self, "_on_enemy_killed"))  # Contador
		enemy_instantiate.connect("robar", Callable(self, "_on_enemy_steal"))  # Contador
		enemy_spawn_area.add_child(enemy_instantiate)
		enemy_count += 1

func _on_enemy_killed(position):
	coinSound.play()
	enemy_count = max(enemy_count - 1, 0)
	player_money += 1  # recompensa por matar
	$Chest/Label.text = str("$ ",player_money)
	show_money_alert(1, position)
	
func _on_enemy_steal(position):
	$RobarSonido.play()
	show_money_alert_reduce(10, position)
	#show_money_alert(10)
	enemy_count = max(enemy_count - 1, 0)
	player_money -= 10
	$Chest/Label.text = str("$ ",player_money)
	if player_money <=0:
		game_over()

func _on_spawn_time_timeout() -> void:
	timeOleadas = max(timeOleadas - 0.2, 2.0)  # Nunca menos de 2 segundos entre oleadas
	numberRange = min(numberRange + 1, 10)  # Nunca más de 10 enemigos por oleada
	var my_random_number = rng.randf_range(1, numberRange)
	spawn_enemy(my_random_number)
	spawn_time.wait_time = timeOleadas

func start_game():
	spawn_time.start()
	spawn_time.wait_time = 10

func game_over():
	get_tree().paused = true

func show_money_alert(amount, position):
	var money_alert = Label.new()
	money_alert.position = position
	money_alert.add_theme_font_size_override("font_size", 40)  # 32px de tamaño
	add_child(money_alert)
	if amount == 0:
		return  # No mostrar nada si no hay cambio

	money_alert.text = ("+ ") + str(abs(amount))
	money_alert.modulate = Color.GREEN
	money_alert.visible = true

	# Animación de desaparición
	var tween = get_tree().create_tween()
	tween.tween_property(money_alert, "modulate:a", 0, 2.0)  # Se desvanece en 2 seg
	await tween.finished
	money_alert.visible = false
	money_alert.modulate.a = 1  # Restaurar opacidad
	money_alert.queue_free()

func show_money_alert_reduce(amount, position):
	#var money_alert = Label.new()
	#money_alert.position = position
	#money_alert.add_theme_font_size_override("font_size", 50)  # 32px de tamaño
	add_child(money_alert)
	if amount == 0:
		return  # No mostrar nada si no hay cambio

	money_alert.text = ("- ") + str(abs(amount))
	money_alert.modulate = Color.RED
	money_alert.visible = true

	# Animación de desaparición
	var tween = get_tree().create_tween()
	tween.tween_property(money_alert, "modulate:a", 0, 2.0)  # Se desvanece en 2 seg
	await tween.finished
	money_alert.visible = false
	money_alert.modulate.a = 1  # Restaurar opacidad
	#money_alert.queue_free()
