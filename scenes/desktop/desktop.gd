extends Control

func _ready() -> void:
	AudioManager.start_song("lofi_1")

func _on_sword_game_button_pressed() -> void:
	GlobalStats.change_scene_async("res://scenes/games/sword_game.tscn")

func _on_web_pressed() -> void:
	GlobalStats.change_scene_async("res://scenes/website/website.tscn")

func _on_web_button_pressed() -> void:
	GlobalStats.change_scene_async("res://scenes/desktop/file.tscn")
