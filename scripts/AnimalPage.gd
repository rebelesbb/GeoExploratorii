extends Node2D

@export var animal_name: String = "animal"
@export var unlock_level: int = 1   # nivelul la care ajunge sanctuarul după pagina asta

@onready var label: Label = $Label        # adaptează calea dacă nu se numește fix "Label"
@onready var button: Button = $Button     # și la fel pentru Button


func _ready() -> void:
	label.text = "Felicitări!\n" + animal_name + " este acum in sanctuar!"



func _on_button_pressed() -> void:
	Global.sanctuary_level = unlock_level

	# mergem la Sanctuar
	get_tree().change_scene_to_file("res://scenes/pages/Sanctuar.tscn")
