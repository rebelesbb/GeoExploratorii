extends Node2D

@onready var background_sprite: Sprite2D = $Sprite2D
# dacă ai alt nume la nodul de fundal, schimbă aici

var backgrounds := {
	0: preload("res://assets/Sanctuar.png"),
	1: preload("res://assets/Padure.png"),
	2: preload("res://assets/Plaja.png"),
	3: preload("res://assets/Gheata.png"),
	4: preload("res://assets/Jungla.png"),
}

var current_bg_index: int = 0

func _ready() -> void:
	_update_animals_visibility()   # la fel ca înainte
	_set_background()              # în plus, setăm și primul fundal


func _update_animals_visibility() -> void:
	var current_level := Global.sanctuary_level

	for child in get_children():
		if child.has_method("update_visibility_by_level"):
			child.update_visibility_by_level(current_level)


func _set_background() -> void:
	if background_sprite and backgrounds.has(current_bg_index):
		background_sprite.texture = backgrounds[current_bg_index]


func _on_ChangeBgButton_pressed() -> void:
	# sau _on_Button_pressed, depinde cum se numește nodul tău
	current_bg_index = (current_bg_index + 1) % backgrounds.size()
	_set_background()
