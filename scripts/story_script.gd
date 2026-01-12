extends Control

func _ready() -> void:
	await get_tree().create_timer(7.0).timeout
	Transition.fade_to_scene("res://scenes/harta.tscn")
