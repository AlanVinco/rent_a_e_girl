extends Control


func _on_button_pressed() -> void:
	GlobalStats.change_scene_async("res://scenes/desktop/desktop.tscn")
