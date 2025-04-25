extends Node

@onready var sound = $Sounds
@onready var loopsound = $LoopSound
@onready var music_player = $AudioManager  # O AudioStreamPlayer3D

func stop_music() -> void:
	music_player.stop()

# Cambiar el volumen globalmente
func set_music_volume(volume: float) -> void:
	music_player.volume_db = volume
