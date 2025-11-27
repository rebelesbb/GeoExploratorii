extends Node2D

@export var current_level: int = 1   # nivelul curent al jucătorului / sanctuarului


func _ready() -> void:
	_update_animals_visibility()


func _update_animals_visibility() -> void:
	# parcurge toți copiii (Animal1, Animal2, etc.)
	for child in get_children():
		# verifică dacă nodul are metoda din Animal.gd
		if child.has_method("update_visibility_by_level"):
			child.update_visibility_by_level(current_level)
