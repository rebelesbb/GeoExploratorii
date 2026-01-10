extends PanelContainer

# Semnal care anunță ce puzzle a fost ales
signal puzzle_selected(index)

@onready var display = $MarginContainer/ImageDisplay
var slot_index: int = 0
var is_locked: bool = true

func setup(index: int, texture_path: String, locked: bool):
	slot_index = index
	is_locked = locked
	
	if is_locked:
		display.texture = load("res://assets/images/lock.png") 
		modulate = Color(0.7, 0.7, 0.7) # Îl facem puțin mai gri/întunecat
	else:
		display.texture = load(texture_path)
		modulate = Color(1, 1, 1) # Culori normale

# Detectăm click-ul pe slot
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_locked:
			puzzle_selected.emit(slot_index)
		else:
			print("Acest nivel este blocat!")
