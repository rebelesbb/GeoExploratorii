@tool
extends Node2D

@export var custom_name: String = ""
@export var required_level: int = 1

@export var sprite_texture: Texture2D:
	set(value):
		sprite_texture = value
		if sprite and value:
			sprite.texture = value

@export var size: float = 0.4:
	set(value):
		size = value
		if sprite:
			sprite.scale = Vector2(size, size)

@export var animal_id: String = ""
@export var use_saved_position: bool = true

const SAVE_PATH := "user://sanctuar_positions.cfg"

var dragging := false
var drag_offset: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D
@onready var name_tag: Control = get_node_or_null("NameTag")
@onready var name_label: Label = get_node_or_null("NameTag/NameLabel")

func _ready() -> void:
	if not sprite:
		push_warning("Lipseste copilul Sprite2D pe " + name)
		return

	if sprite_texture:
		sprite.texture = sprite_texture

	sprite.scale = Vector2(size, size)

	if not Engine.is_editor_hint() and use_saved_position:
		_load_saved_data()

	_update_name_label()

func _load_saved_data() -> void:
	if animal_id == "":
		return

	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		return

	if config.has_section_key("sanctuar", animal_id + "_x") and config.has_section_key("sanctuar", animal_id + "_y"):
		var x = float(config.get_value("sanctuar", animal_id + "_x"))
		var y = float(config.get_value("sanctuar", animal_id + "_y"))
		global_position = Vector2(x, y)

	if config.has_section_key("sanctuar", animal_id + "_name"):
		custom_name = str(config.get_value("sanctuar", animal_id + "_name"))

func _update_name_label() -> void:
	if not name_label:
		return

	var text := custom_name.strip_edges()
	if text == "":
		if name_tag:
			name_tag.visible = false
		name_label.text = ""
		return

	if name_tag:
		name_tag.visible = true
	name_label.text = text

func update_visibility_by_level(current_level: int) -> void:
	visible = current_level >= required_level

func _on_HomeButton_pressed() -> void:
	Transition.fade_to_scene("res://scenes/harta.tscn")

func _input(event: InputEvent) -> void:
	if not visible or not sprite:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var local_pos = sprite.to_local(event.position)
			if sprite.get_rect().has_point(local_pos):
				dragging = true
				drag_offset = global_position - event.position
		else:
			if dragging and not Engine.is_editor_hint():
				_save_data()
			dragging = false

	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + drag_offset

func _save_data() -> void:
	if animal_id == "":
		return

	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		pass

	config.set_value("sanctuar", animal_id + "_x", global_position.x)
	config.set_value("sanctuar", animal_id + "_y", global_position.y)
	config.set_value("sanctuar", animal_id + "_name", custom_name)

	config.save(SAVE_PATH)

func set_custom_name(new_name: String) -> void:
	custom_name = new_name.strip_edges()
	_update_name_label()

	if not Engine.is_editor_hint():
		_save_data()
