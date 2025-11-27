extends Control

@onready var sidebar: Panel = $Sidebar
@onready var menu_button: Button = $MenuButton
@onready var play_button: Button = $playButton

@onready var sanctuar_button: Button = $Sidebar/VBoxContainer/sanctuarButton
@onready var puzzle_button: Button = $Sidebar/VBoxContainer/puzzleButton
@onready var info_button: Button = $Sidebar/VBoxContainer/infoButton

@onready var old_map: TextureRect = $OldMap
@onready var new_map: TextureRect = $NewMap

@onready var city_buttons: Control      = $NewMap/CityButtons

@onready var timisoara_label: Label     = $TimisoaraLabel
@onready var cluj_label: Label          = $"Cluj-Napoca"
@onready var bucuresti_label: Label     = $BucurestiLabel
@onready var brasov_label: Label        = $Brasovlabel
@onready var iasi_label: Label          = $IasiLabel
@onready var constanta_label: Label     = $ConstantaLbel

var all_city_labels: Array[Label]

# map textures
const MAP_TEXTURES := [
	preload("res://assets/maps/harta_muta.png"),
	preload("res://assets/maps/harta_vecini.png"),
	preload("res://assets/maps/harta_relief.png"),
	preload("res://assets/maps/harta_ape.png"),
	preload("res://assets/maps/harta_activitati.png"),
	preload("res://assets/maps/harta_cluj.png")
]

const ACTIVITIES_MAP_LEVEL := 4
const CLUJ_MAP_LEVEL := 5

const QUIZ_SCENE_PATH := "res://scenes/Quiz.tscn"
const SANCTUAR_SCENE_PATH := "res://scenes/Sanctuar.tscn"
const PUZZLE_SCENE_PATH := "res://scenes/Puzzle.tscn"
const INFO_SCENE_PATH := "res://scenes/Info.tscn"

var last_level: int = 0

func _ready() -> void:
	sidebar.visible = false
	
	old_map.mouse_filter = Control.MOUSE_FILTER_IGNORE
	new_map.mouse_filter = Control.MOUSE_FILTER_IGNORE
	city_buttons.mouse_filter = Control.MOUSE_FILTER_STOP

	menu_button.pressed.connect(_on_menu_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	sanctuar_button.pressed.connect(_on_sanctuar_button_pressed)
	puzzle_button.pressed.connect(_on_puzzle_button_pressed)
	info_button.pressed.connect(_on_info_button_pressed)
	
	all_city_labels = [
		timisoara_label,
		cluj_label,
		bucuresti_label,
		brasov_label,
		iasi_label,
		constanta_label,
	]
	_hide_all_city_labels()
	
	$NewMap/CityButtons/ClujButton.pressed.connect(_on_city_button_pressed.bind("cluj"))
	$NewMap/CityButtons/TimisoaraButton.pressed.connect(_on_city_button_pressed.bind("timisoara"))
	$NewMap/CityButtons/BucurestiButton.pressed.connect(_on_city_button_pressed.bind("bucuresti"))
	$NewMap/CityButtons/BrasovButton.pressed.connect(_on_city_button_pressed.bind("brasov"))
	$NewMap/CityButtons/IasiButton.pressed.connect(_on_city_button_pressed.bind("iasi"))
	$NewMap/CityButtons/ConstantaButton.pressed.connect(_on_city_button_pressed.bind("constanta"))
	
	last_level = Global.current_level
	_set_initial_map()

func _set_initial_map() -> void:
	var lvl: int = clamp(Global.current_level, 0, MAP_TEXTURES.size() - 1)
	new_map.texture = MAP_TEXTURES[lvl]
	new_map.modulate.a = 1.0
	old_map.modulate.a = 0.0
	_update_city_ui_for_level(lvl)

func update_map_with_fade() -> void:
	var new_level: int = clamp(Global.current_level, 0, MAP_TEXTURES.size() - 1)
	
	_update_city_ui_for_level(new_level)

	if new_level == last_level:
		new_map.texture = MAP_TEXTURES[new_level]
		return

	old_map.texture = MAP_TEXTURES[last_level]
	new_map.texture = MAP_TEXTURES[new_level]

	old_map.modulate.a = 1.0
	new_map.modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(new_map, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_property(old_map, "modulate:a", 0.0, 0.5)

	last_level = new_level
	
func _hide_all_city_labels() -> void:
	for lbl in all_city_labels:
		lbl.visible = false
		
func _update_city_ui_for_level(level: int) -> void:
	var show_cities := (level == ACTIVITIES_MAP_LEVEL
		or level == CLUJ_MAP_LEVEL)

	city_buttons.visible = show_cities

	if not show_cities:
		_hide_all_city_labels()
		
func _on_city_button_pressed(city: String) -> void:
	print("APASAT ORAS: ", city)  # <= DEBUG
	_hide_all_city_labels()

	match city:
		"cluj":
			cluj_label.visible = true
		"timisoara":
			timisoara_label.visible = true
		"bucuresti":
			bucuresti_label.visible = true
		"brasov":
			brasov_label.visible = true
		"iasi":
			iasi_label.visible = true
		"constanta":
			constanta_label.visible = true

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
