@tool
extends Node2D

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
			
@export var animal_id: String = ""   # ID unic pentru fiecare animal
@export var use_saved_position: bool = true 

const SAVE_PATH := "user://sanctuar_positions.cfg"

var dragging := false
var drag_offset: Vector2 = Vector2.ZERO
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	# dacă din greșeală nu există Sprite2D, nu mai crăpă jocul
	if not sprite:
		push_warning("Lipseste copilul Sprite2D pe " + name)
		return

	if sprite_texture:
		sprite.texture = sprite_texture

	sprite.scale = Vector2(size, size)

	# dacă suntem în joc (nu în editor), încearcă să încarci poziția salvată
	if not Engine.is_editor_hint() and use_saved_position:
		_load_saved_position()
		
		

func _load_saved_position() -> void:
	if animal_id == "":
		return

	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		return

	# poziția este salvată ca două float-uri
	if config.has_section_key("sanctuar", animal_id + "_x") and config.has_section_key("sanctuar", animal_id + "_y"):
		var x = config.get_value("sanctuar", animal_id + "_x")
		var y = config.get_value("sanctuar", animal_id + "_y")
		global_position = Vector2(x, y)



func update_visibility_by_level(current_level: int) -> void:
	visible = current_level >= required_level

func _on_HomeButton_pressed():
	Transition.fade_to_scene("res://scenes/harta.tscn")

func _input(event: InputEvent) -> void:
	# dacă nu e vizibil sau nu avem sprite, nu facem nimic
	if not visible or not sprite:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# convertim poziția mouse-ului în coordonate locale ale sprite-ului
				var local_pos = sprite.to_local(event.position)
				if sprite.get_rect().has_point(local_pos):
					dragging = true
					# ca să nu sară animalul sub mouse
					drag_offset = global_position - event.position
			else:
				# am ridicat click-ul → oprim dragging și salvăm poziția
				if dragging and not Engine.is_editor_hint():
					_save_position()
				dragging = false

	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + drag_offset


func _save_position() -> void:
	if animal_id == "":
		return

	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		# dacă fișierul nu există încă, nu e problemă
		pass

	config.set_value("sanctuar", animal_id + "_x", global_position.x)
	config.set_value("sanctuar", animal_id + "_y", global_position.y)

	config.save(SAVE_PATH)
