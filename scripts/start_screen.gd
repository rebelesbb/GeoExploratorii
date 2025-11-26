extends Control

@onready var name_input = $VBoxContainer/NameInput
@onready var start_button = $VBoxContainer/StartButton
@onready var quit_button = $CloseButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	var player_name = name_input.text.strip_edges()
	if player_name == "":
		name_input.placeholder_text = "Te rog scrie numele!"
		return

	Global.player_name = player_name
#	aici trecem la Home page
	get_tree().change_scene_to_file("res://scenes/Harta.tscn")

func _on_quit_pressed():
	get_tree().quit()
