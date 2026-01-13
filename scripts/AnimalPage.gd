extends Node2D

@export var animal_name: String = "animal"
@export var unlock_level: int = 1  
@export var animal_id: String = ""  

const SAVE_PATH := "user://sanctuar_positions.cfg"

@onready var label: Label = $Label
@onready var button: Button = $Button
@onready var name_input: LineEdit = $NameInput


func _ready() -> void:
	label.text = "Felicitări!\n" + animal_name + " este acum in sanctuar!"
	if name_input:
		name_input.placeholder_text = "Alege un nume pentru " + animal_name 


func _on_HomeButton_pressed():
	Transition.fade_to_scene("res://scenes/harta.tscn")


func _on_button_pressed() -> void:
	_save_animal_name(name_input.text)

	Global.sanctuary_level = unlock_level
	get_tree().change_scene_to_file("res://scenes/pages/Sanctuar.tscn")


func _save_animal_name(chosen_name: String) -> void:
	if animal_id == "":
		return

	var final_name := chosen_name.strip_edges()
	if final_name == "":
		final_name = animal_name  

	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		pass

	config.set_value("sanctuar", animal_id + "_name", final_name)
	config.save(SAVE_PATH)
