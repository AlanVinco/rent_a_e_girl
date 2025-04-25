extends Control

@export var text = ""

func _ready() -> void:
	$Label.text = text
