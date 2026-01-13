extends CanvasLayer

signal piece_displayed_and_closed

@onready var puzzle_image = $CenterContainer/PanelContainer/VBoxContainer/PuzzlePieceImage 
@onready var next_button = $CenterContainer/PanelContainer/VBoxContainer/PanelContainer/NextQuestionButton

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

# funcite apelata din quiz_page.gd
func display_puzzle_piece(chapter_id: int, question_id: int):
	print("PuzzleImage found? ", puzzle_image)
	var file_path = "res://assets/puzzle_pieces/Cap%d/%d.%d.png" % [chapter_id, chapter_id, question_id]
	
	var texture = load(file_path)
	puzzle_image.texture = texture
	

func _ready():
	display_confetti()

func _on_next_question_button_pressed():
	emit_signal("piece_displayed_and_closed")
	
	queue_free()
