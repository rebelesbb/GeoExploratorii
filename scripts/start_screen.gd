extends Control

@onready var name_input = $VBoxContainer/NameInput
@onready var start_button = $VBoxContainer/StartButton
@onready var quit_button = $CloseButton

var _start_tween: Tween
var _base_pos: Vector2

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	_start_start_button_hint()

func _start_start_button_hint() -> void:
	_base_pos = start_button.position

	if _start_tween and is_instance_valid(_start_tween):
		_start_tween.kill()

	start_button.position = _base_pos
	start_button.modulate.a = 1.0

	_start_tween = create_tween()
	_start_tween.set_loops()
	_start_tween.set_trans(Tween.TRANS_SINE)
	_start_tween.set_ease(Tween.EASE_IN_OUT)

	_start_tween.parallel().tween_property(start_button, "modulate:a", 0.7, 0.5)
	_start_tween.tween_property(start_button, "modulate:a", 1.0, 0.5)

func _on_start_pressed():
	if _start_tween and is_instance_valid(_start_tween):
		_start_tween.kill()

	var player_name = name_input.text.strip_edges()
	if player_name == "":
		name_input.placeholder_text = "Te rog scrie numele!"
		return

	Global.player_name = player_name
	Transition.fade_to_scene("res://scenes/StoryScreen.tscn")

func _on_quit_pressed():
	Global.clear_save()
	Transition.fade_and_quit()
