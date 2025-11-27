extends Control

@onready var sidebar: Panel = $Sidebar
@onready var menu_button: Button = $MenuButton
@onready var play_button: Button = $playButton

@onready var sanctuar_button: Button = $Sidebar/VBoxContainer/sanctuarButton
@onready var puzzle_button: Button = $Sidebar/VBoxContainer/puzzleButton
@onready var info_button: Button = $Sidebar/VBoxContainer/infoButton

const QUIZ_SCENE_PATH      := "res://scenes/Quiz.tscn"
const SANCTUAR_SCENE_PATH  := "res://scenes/Sanctuar.tscn"
const PUZZLE_SCENE_PATH    := "res://scenes/Puzzle.tscn"
const INFO_SCENE_PATH      := "res://scenes/Info.tscn"

func _ready() -> void:
	sidebar.visible = false

	menu_button.pressed.connect(_on_menu_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	sanctuar_button.pressed.connect(_on_sanctuar_button_pressed)
	puzzle_button.pressed.connect(_on_puzzle_button_pressed)
	info_button.pressed.connect(_on_info_button_pressed)

func _on_menu_button_pressed() -> void:
	sidebar.visible = not sidebar.visible

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(QUIZ_SCENE_PATH)

func _on_sanctuar_button_pressed() -> void:
	get_tree().change_scene_to_file(SANCTUAR_SCENE_PATH)

func _on_puzzle_button_pressed() -> void:
	get_tree().change_scene_to_file(PUZZLE_SCENE_PATH)

func _on_info_button_pressed() -> void:
	get_tree().change_scene_to_file(INFO_SCENE_PATH)
