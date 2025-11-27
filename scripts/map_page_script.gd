extends Control

@onready var sidebar: Panel = $Sidebar
@onready var menu_button: Button = $MenuButton
@onready var play_button: Button = $playButton

@onready var sanctuar_button: Button = $Sidebar/VBoxContainer/sanctuarButton
@onready var puzzle_button: Button = $Sidebar/VBoxContainer/puzzleButton
@onready var info_button: Button = $Sidebar/VBoxContainer/infoButton

@onready var old_map: TextureRect = $OldMap
@onready var new_map: TextureRect = $NewMap

# map textures
const MAP_TEXTURES := [
	preload("res://assets/maps/harta_muta.png"),
	preload("res://assets/maps/harta_vecini.png"),
	preload("res://assets/maps/harta_relief.png"),
	preload("res://assets/maps/harta_ape.png"),
]

const QUIZ_SCENE_PATH      := "res://scenes/Quiz.tscn"
const SANCTUAR_SCENE_PATH  := "res://scenes/Sanctuar.tscn"
const PUZZLE_SCENE_PATH    := "res://scenes/Puzzle.tscn"
const INFO_SCENE_PATH      := "res://scenes/Info.tscn"

var last_level: int = 0

func _ready() -> void:
	sidebar.visible = false

	menu_button.pressed.connect(_on_menu_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	sanctuar_button.pressed.connect(_on_sanctuar_button_pressed)
	puzzle_button.pressed.connect(_on_puzzle_button_pressed)
	info_button.pressed.connect(_on_info_button_pressed)
	
	last_level = Global.current_level
	_set_initial_map()

func _set_initial_map() -> void:
	var lvl: int = clamp(Global.current_level, 0, MAP_TEXTURES.size() - 1)
	new_map.texture = MAP_TEXTURES[lvl]
	new_map.modulate.a = 1.0
	old_map.modulate.a = 0.0

func update_map_with_fade() -> void:
	var new_level: int = clamp(Global.current_level, 0, MAP_TEXTURES.size() - 1)

	# dacă e primul nivel sau nu s-a schimbat nivelul, doar punem textura direct
	if new_level == last_level:
		new_map.texture = MAP_TEXTURES[new_level]
		return

	# setăm texturile
	old_map.texture = MAP_TEXTURES[last_level]
	new_map.texture = MAP_TEXTURES[new_level]

	# resetăm alpha: vechea hartă 100%, noua 0%
	old_map.modulate.a = 1.0
	new_map.modulate.a = 0.0

	# tween pentru fade
	var tween: Tween = create_tween()
	tween.tween_property(new_map, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_property(old_map, "modulate:a", 0.0, 0.5)

	last_level = new_level

func _on_menu_button_pressed() -> void:
	sidebar.visible = not sidebar.visible

func _on_play_button_pressed() -> void:
	Global.current_level += 1
	print(Global.current_level)
	update_map_with_fade()
	get_tree().change_scene_to_file(QUIZ_SCENE_PATH)

func _on_sanctuar_button_pressed() -> void:
	get_tree().change_scene_to_file(SANCTUAR_SCENE_PATH)

func _on_puzzle_button_pressed() -> void:
	get_tree().change_scene_to_file(PUZZLE_SCENE_PATH)

func _on_info_button_pressed() -> void:
	get_tree().change_scene_to_file(INFO_SCENE_PATH)
