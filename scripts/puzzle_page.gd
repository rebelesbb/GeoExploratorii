extends Control

@onready var puzzle_container = $PuzzleContainer
@onready var congrats_layer = $CongratsLayer
@onready var feedback_label = $CongratsLayer/ColorRect/CongratsLabel

# Config
const PIECE_SIZE = Vector2(280, 280)
const SNAP_DISTANCE = 20.0           # distanta pentru unire
const NEXT_SCENE_PATH = "res://scenes/harta.tscn"

# harta conexiuni piese
const CONNECTION_MAP = {
	0: {"right": 1, "bottom": 3},
	1: {"right": 2, "bottom": 4},
	2: {"right": null, "bottom": 5},
	3: {"right": 4, "bottom": null},
	4: {"right": 5, "bottom": null},
	5: {"right": null, "bottom": null}
}

var pieces: Array = []
var game_won = false

func _ready():
	for child in puzzle_container.get_children():
		if child is TextureRect and child.has_method("initialize"):
			pieces.append(child)
	
	_initialize_pieces()

func _initialize_pieces():
	var screen_size = get_viewport_rect().size
	
	# Safety margin ca sa nu iasa din ecran
	var margin_x = PIECE_SIZE.x + 20
	var margin_y = PIECE_SIZE.y + 20
	
	var chapter_id = Global.current_level 
	
	for i in range(pieces.size()):
		var p = pieces[i]
		var piece_nr = i + 1 
		var img_path = "res://assets/puzzle_pieces/Cap%d/%d.%d.png" % [chapter_id, chapter_id, piece_nr]
		var texture = load(img_path)
		
		if texture:
			p.texture = texture
		else:
			printerr("Eroare la incarcare textura de la: ", img_path)	
		
		# Init piesa
		p.initialize(i, PIECE_SIZE, CONNECTION_MAP, SNAP_DISTANCE)
		
		# Poz random 
		var random_x = randf_range(20, screen_size.x - margin_x)
		var random_y = randf_range(20, screen_size.y - margin_y)
		
		p.global_position = Vector2(random_x, random_y)

func check_win_condition():
	if game_won:
		return
		
	if puzzle_container.get_child_count() == 1:
		_on_puzzle_complete()

func display_confetti():
	var conffeti_textures = [
		load("res://assets/confetti/blue.png"),
		load("res://assets/confetti/red.png"),
		load("res://assets/confetti/yellow.png"),
		load("res://assets/confetti/purple.png")
	]
	
	var count = 500
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	var screen_size = get_viewport().get_visible_rect().size 
	
	for i in range(count):
		var sprite = Sprite2D.new()
		sprite.texture = conffeti_textures[rnd.randi_range(0, conffeti_textures.size() - 1)]
		sprite.position = Vector2(
			 rnd.randf_range(0, screen_size.x),
			-20 
		)
		var scale = rnd.randf_range(0.02, 0.10)
		sprite.scale = Vector2(scale, scale)
		add_child(sprite)
		
		var tween = create_tween()
		var velocity = Vector2(rnd.randf_range(-50, 50), rnd.randf_range(100, 300))
		tween.tween_property(sprite, "position", sprite.position + velocity, 2.0)
		tween.parallel().tween_property(sprite, "modulate:a", 0.0, 1.2).set_delay(1.0)
		tween.tween_callback(sprite.queue_free)

func _on_puzzle_complete():
	game_won = true
	await get_tree().create_timer(0.5).timeout
	#
	display_confetti()
	#congrats_layer.visible = true
	
	await get_tree().create_timer(2.0).timeout
	# după puzzle → dă animalul
	var animal_scene = Global.animal_scenes.get(Global.current_level, "")
	Transition.fade_to_scene(animal_scene)


func get_all_pieces_reference():
	return pieces

func _on_home_button_pressed() -> void:
	Transition.fade_to_scene("res://scenes/harta.tscn")
