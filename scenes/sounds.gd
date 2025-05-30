extends Node

@onready var sound = $Sounds
@onready var loopsound = $LoopSound
@onready var music_player = $AudioManager  # O AudioStreamPlayer3D

var current_clip = ""
var clip_durations = {
	"MONEY_GAME_THEME": 52.87,  # Duración en segundos
	"lofi_1": 137.0,
	"DEE_THEME": 199.003,
	"PAGE_THEME": 116.189,
	"VIDEOCALL_THEME":8.07,
	# Agrega más clips y su duración aquí
}

var loop_timer: Timer

#func _ready() -> void:
	#music_player.play()
	#start_loop_for("lofi_1")  # Canción inicial

func start_loop_for(clip_name: String) -> void:
	current_clip = clip_name
	music_player["parameters/switch_to_clip"] = clip_name

	if loop_timer:
		loop_timer.stop()
		loop_timer.queue_free()

	# Crear nuevo timer con la duración del clip
	loop_timer = Timer.new()
	var duration = clip_durations.get(clip_name, 60.0)  # Valor por defecto si no se encuentra
	loop_timer.wait_time = duration
	loop_timer.one_shot = true
	loop_timer.timeout.connect(_on_timer_timeout)
	add_child(loop_timer)
	loop_timer.start()

func _on_timer_timeout() -> void:
	# Reproduce de nuevo el mismo clip
	start_loop_for(current_clip)

func stop_music() -> void:
	music_player.stop()
	if loop_timer:
		loop_timer.stop()

func set_music_volume(volume: float) -> void:
	music_player.volume_db = volume

func start_song(song_name):
	if music_player.playing:
		if song_name != music_player["parameters/switch_to_clip"]:
			start_loop_for(song_name)
			music_player["parameters/switch_to_clip"] = song_name
	else:
		music_player["parameters/switch_to_clip"] = song_name
		start_loop_for(song_name)
		music_player.play()
