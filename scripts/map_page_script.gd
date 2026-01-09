extends Control

@onready var sidebar: Panel = $Sidebar
@onready var menu_button: Button = $MenuButton
@onready var play_button: Button = $playButton
@onready var refresh_button: Button = $refreshButton

var _play_hint_tween: Tween
var _sidebar_tween: Tween
var _sidebar_items: Array[Control] = []
var _sidebar_item_base_pos: Dictionary[Control, Vector2] = {}

const SIDEBAR_ITEM_SLIDE := 70.0
const SIDEBAR_ITEM_STAGGER := 0.06
const SIDEBAR_ITEM_DURATION := 0.22


@onready var sanctuar_button: Button = $Sidebar/VBoxContainer/sanctuarButton
@onready var puzzle_button: Button = $Sidebar/VBoxContainer/puzzleButton
@onready var info_button: Button = $Sidebar/VBoxContainer/infoButton
@onready var expert_button: Button = $Sidebar/VBoxContainer/expertButton

@onready var old_map: TextureRect = $OldMap
@onready var new_map: TextureRect = $NewMap

@onready var city_buttons: Control      = $NewMap/CityButtons

@onready var timisoara_label: Label     = $TimisoaraLabel
@onready var cluj_label: Label          = $"Cluj-Napoca"
@onready var bucuresti_label: Label     = $BucurestiLabel
@onready var brasov_label: Label        = $Brasovlabel
@onready var iasi_label: Label          = $IasiLabel
@onready var constanta_label: Label     = $ConstantaLbel

@onready var music_toggle: Button = $Sidebar/VBoxContainer/HBoxContainer/musicButton
@onready var sound_toggle: Button = $Sidebar/VBoxContainer/HBoxContainer/clickButton

const TEX_MUSIC_ON  := preload("res://assets/maps/buttons/music_on.png")
const TEX_MUSIC_OFF := preload("res://assets/maps/buttons/music_off.png")
const TEX_SOUND_ON  := preload("res://assets/maps/buttons/sound_on.png")
const TEX_SOUND_OFF := preload("res://assets/maps/buttons/sound_off.png")


var all_city_labels: Array[Label]

# map textures
const MAP_TEXTURES := [
	preload("res://assets/maps/harta_muta.png"),
	preload("res://assets/maps/harta_vecini.png"),
	preload("res://assets/maps/harta_relief.png"),
	preload("res://assets/maps/harta_ape.png"),
	preload("res://assets/maps/harta_asezari.png"),
	preload("res://assets/maps/harta_activitati.png"),
	preload("res://assets/maps/harta_activitati.png"),
	preload("res://assets/maps/harta_cluj.png")
]

const ACTIVITIES_MAP_LEVEL := 4
const CLUJ_MAP_LEVEL := 5
const MAX_CHAPTERS = 7

const QUIZ_SCENE_PATH := "res://scenes/QuizPage.tscn"
const SANCTUAR_SCENE_PATH := "res://scenes/pages/Sanctuar.tscn"
const PUZZLE_SCENE_PATH := "res://scenes/Puzzle.tscn"
const INFO_SCENE_PATH := "res://scenes/Info.tscn"
const APE_SCENE_PATH := "res://scenes/ApeRelief.tscn"

var last_level: int = 0

func _ready() -> void:
	sidebar.visible = false
	call_deferred("_init_sidebar_layout_cache")
	#_cache_sidebar_items()
	_prepare_sidebar_closed_state()
	
	old_map.mouse_filter = Control.MOUSE_FILTER_IGNORE
	new_map.mouse_filter = Control.MOUSE_FILTER_IGNORE
	city_buttons.mouse_filter = Control.MOUSE_FILTER_STOP

	menu_button.pressed.connect(_on_menu_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	sanctuar_button.pressed.connect(_on_sanctuar_button_pressed)
	puzzle_button.pressed.connect(_on_puzzle_button_pressed)
	info_button.pressed.connect(_on_info_button_pressed)
	expert_button.pressed.connect(_on_expert_bttn_pressed)
	
	if refresh_button:
		refresh_button.pressed.connect(_on_refresh_button_pressed)

	_check_game_finished()
	
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
	
	last_level = clamp(Global.current_level - 1, 0, MAP_TEXTURES.size() - 1)
	_set_initial_map()
	if Global.should_animate :
		update_map_with_fade()
		Global.should_animate = false
	music_toggle.pressed.connect(_on_music_toggle_pressed)
	sound_toggle.pressed.connect(_on_sound_toggle_pressed)
	_refresh_audio_icons()
	
func _init_sidebar_layout_cache() -> void:
	sidebar.visible = true
	sidebar.modulate.a = 0.0

	var vbox := sidebar.get_node("VBoxContainer") as VBoxContainer
	vbox.queue_sort()

	await get_tree().process_frame

	_cache_sidebar_items()

	_prepare_sidebar_closed_state()

	sidebar.modulate.a = 1.0

func _check_game_finished():
	var is_finished = (Global.current_level >= MAX_CHAPTERS)
	
	play_button.visible = !is_finished
	if refresh_button:
		refresh_button.visible = is_finished
		
	_restart_play_hint_if_needed()
		
func _on_refresh_button_pressed():
	Global.reset_full_game()
	Transition.fade_to_scene("res://scenes/StartScreen.tscn")
	
func _on_music_toggle_pressed() -> void:
	var new_enabled = not MusicPlayer.is_enabled()
	MusicPlayer.set_enabled(new_enabled)
	_refresh_audio_icons()

func _on_sound_toggle_pressed() -> void:
	var new_enabled = not Click.is_enabled()
	Click.set_enabled(new_enabled)
	_refresh_audio_icons()

func _refresh_audio_icons() -> void:
	music_toggle.icon = TEX_MUSIC_ON if MusicPlayer.is_enabled() else TEX_MUSIC_OFF
	sound_toggle.icon = TEX_SOUND_ON if Click.is_enabled() else TEX_SOUND_OFF

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
	_restart_play_hint_if_needed()
	
func _hide_all_city_labels() -> void:
	for lbl in all_city_labels:
		lbl.visible = false
		
func _update_city_ui_for_level(level: int) -> void:
	var show_cities := (level >= ACTIVITIES_MAP_LEVEL)

	city_buttons.visible = show_cities

	if not show_cities:
		_hide_all_city_labels()
		
func _on_city_button_pressed(city: String) -> void:
	print("APASAT ORAS: ", city)
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
	if sidebar.visible:
		_animate_sidebar_close()
	else:
		_animate_sidebar_open()

func _on_expert_bttn_pressed() -> void:
	Transition.fade_to_scene(APE_SCENE_PATH)

func _on_play_button_pressed() -> void:
	print("PLAY: before=", Global.current_level, " quiz_state=", Global.quiz_state)

	Global.current_level += 1
	Global.quiz_state = {"active": false}
	Global.save_game()
	print(Global.current_level)
	Global.should_animate = true
	Transition.fade_to_scene(QUIZ_SCENE_PATH)

func _on_sanctuar_button_pressed() -> void:
	Transition.fade_to_scene(SANCTUAR_SCENE_PATH)

func _on_puzzle_button_pressed() -> void:
	get_tree().change_scene_to_file(PUZZLE_SCENE_PATH)

func _on_info_button_pressed() -> void:
	Transition.fade_to_scene("res://scenes/StatsPage.tscn")

func _restart_play_hint_if_needed() -> void:
	if not is_instance_valid(play_button):
		return

	if not play_button.visible:
		_stop_play_hint()
		return

	_start_play_hint()


func _start_play_hint() -> void:
	_stop_play_hint()

	var base_pos := play_button.position

	_play_hint_tween = create_tween()
	_play_hint_tween.set_loops()
	_play_hint_tween.set_trans(Tween.TRANS_SINE)
	_play_hint_tween.set_ease(Tween.EASE_IN_OUT)

	_play_hint_tween.tween_property(play_button, "position:y", base_pos.y - 6, 0.4)
	_play_hint_tween.tween_property(play_button, "position:y", base_pos.y, 0.4)

	_play_hint_tween.parallel().tween_property(play_button, "modulate:a", 0.65, 0.4)
	_play_hint_tween.tween_property(play_button, "modulate:a", 1.0, 0.4)

func _stop_play_hint() -> void:
	if _play_hint_tween and is_instance_valid(_play_hint_tween):
		_play_hint_tween.kill()
	_play_hint_tween = null

	if is_instance_valid(play_button):
		play_button.modulate.a = 1.0

func _on_play_mouse_entered() -> void:
	_stop_play_hint()

func _on_play_mouse_exited() -> void:
	_restart_play_hint_if_needed()
	
func _cache_sidebar_items() -> void:
	_sidebar_items.clear()
	_sidebar_item_base_pos.clear()

	var vbox := sidebar.get_node("VBoxContainer") as VBoxContainer

	for n: Node in vbox.get_children():
		var c := n as Control
		if c == null:
			continue

		_sidebar_items.append(c)
		_sidebar_item_base_pos[c] = c.position
			
func _prepare_sidebar_closed_state() -> void:
	sidebar.visible = false

	for item in _sidebar_items:
		if not is_instance_valid(item): 
			continue
		item.position = _sidebar_item_base_pos[item] + Vector2(-SIDEBAR_ITEM_SLIDE, 0.0)
		item.modulate.a = 0.0
		
func _animate_sidebar_open() -> void:
	_kill_sidebar_tween()

	sidebar.visible = true

	_sidebar_tween = create_tween()
	_sidebar_tween.set_trans(Tween.TRANS_SINE)
	_sidebar_tween.set_ease(Tween.EASE_OUT)

	for i in range(_sidebar_items.size()):
		var item := _sidebar_items[i]
		if not is_instance_valid(item):
			continue

		item.position = _sidebar_item_base_pos[item] + Vector2(-SIDEBAR_ITEM_SLIDE, 0)
		item.modulate.a = 0.0

		var delay := i * SIDEBAR_ITEM_STAGGER
		_sidebar_tween.parallel().tween_property(item, "position", _sidebar_item_base_pos[item], SIDEBAR_ITEM_DURATION).set_delay(delay)
		_sidebar_tween.parallel().tween_property(item, "modulate:a", 1.0, SIDEBAR_ITEM_DURATION).set_delay(delay)


func _animate_sidebar_close() -> void:
	_kill_sidebar_tween()

	_sidebar_tween = create_tween()
	_sidebar_tween.set_trans(Tween.TRANS_SINE)
	_sidebar_tween.set_ease(Tween.EASE_IN)

	for j in range(_sidebar_items.size()):
		var i := _sidebar_items.size() - 1 - j
		var item := _sidebar_items[i]
		if not is_instance_valid(item):
			continue

		var delay := j * SIDEBAR_ITEM_STAGGER
		var target_pos: Vector2 = _sidebar_item_base_pos[item] + Vector2(-SIDEBAR_ITEM_SLIDE, 0.0)

		_sidebar_tween.parallel().tween_property(item, "position", target_pos, SIDEBAR_ITEM_DURATION).set_delay(delay)
		_sidebar_tween.parallel().tween_property(item, "modulate:a", 0.0, SIDEBAR_ITEM_DURATION).set_delay(delay)

	var total_time := (_sidebar_items.size() - 1) * SIDEBAR_ITEM_STAGGER + SIDEBAR_ITEM_DURATION
	_sidebar_tween.tween_callback(func(): sidebar.visible = false).set_delay(total_time)

func _kill_sidebar_tween() -> void:
	if _sidebar_tween and is_instance_valid(_sidebar_tween):
		_sidebar_tween.kill()
	_sidebar_tween = null
