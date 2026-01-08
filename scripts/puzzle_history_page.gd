extends Control

var puzzle_images = [
	"res://assets/puzzle_pieces/full_puzzle/puzzle1.png",
	"res://assets/puzzle_pieces/full_puzzle/puzzle2.png",
	"res://assets/puzzle_pieces/full_puzzle/puzzle3.png",
	"res://assets/puzzle_pieces/full_puzzle/puzzle4.png",
	"res://assets/puzzle_pieces/full_puzzle/puzzle5.png",
	"res://assets/puzzle_pieces/full_puzzle/puzzle6.png",
	"res://assets/puzzle_pieces/full_puzzle/puzzle7.png"
]

@onready var grid = $CenterContainer/PuzzleGrid
@onready var last_slot_container = $CenterContainer/LastLvlContainer

func _ready():
	setup_history()

func setup_history():
	var all_slots = grid.get_children()
	all_slots.append(last_slot_container.get_child(0))
	
	for i in range(all_slots.size()):
		var slot = all_slots[i]
		
		var locked = i >= Global.current_level
		
		slot.setup(i, puzzle_images[i], locked)
		
		if not slot.puzzle_selected.is_connected(_on_puzzle_clicked):
			slot.puzzle_selected.connect(_on_puzzle_clicked)

func _on_puzzle_clicked(index):
	Global.puzzle_level = index + 1
	Global.animal_flag = false
	Transition.fade_to_scene("res://scenes/puzzle/PuzzlePage.tscn")
	
func _on_home_button_pressed() -> void:
	Transition.fade_to_scene("res://scenes/harta.tscn")
