extends Node

@onready var money: Label = $money

func _ready() -> void:
	GlobalStats.money_changed.connect(_update_stats)
	_update_stats()
	
func _update_stats():
	money.text = str(GlobalStats.money)
