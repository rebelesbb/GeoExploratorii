extends Node2D

@onready var background_sprite: Sprite2D = $Sprite2D
const SAVE_PATH := "user://sanctuar_positions.cfg" 
const BG_KEY := "bg_index"


var backgrounds := {
	0: preload("res://assets/Sanctuar.png"),
	1: preload("res://assets/Padure.png"),
	2: preload("res://assets/Plaja.png"),
	3: preload("res://assets/Gheata.png"),
	4: preload("res://assets/Jungla.png"),
}

var current_bg_index: int = 0

func _ready() -> void:
	_update_animals_visibility()
	_load_background_index()
	_set_background()
		  

func _update_animals_visibility() -> void:
	var current_level = Global.current_level

	for child in get_children():
		if child.has_method("update_visibility_by_level"):
			child.update_visibility_by_level(current_level)

func _set_background() -> void:
	if background_sprite and backgrounds.has(current_bg_index):
		background_sprite.texture = backgrounds[current_bg_index]

func _on_ChangeBgButton_pressed() -> void:
	current_bg_index = (current_bg_index + 1) % backgrounds.size()
	_set_background()
	_save_background_index()

func _on_HomeButton_pressed():
	Transition.fade_to_scene("res://scenes/harta.tscn")
	
func _load_background_index() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		return

	if config.has_section_key("sanctuar", BG_KEY):
		current_bg_index = int(config.get_value("sanctuar", BG_KEY))

func _save_background_index() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		pass

	config.set_value("sanctuar", BG_KEY, current_bg_index)
	config.save(SAVE_PATH)
