extends Control

@onready var image: TextureRect = $Image
@onready var left_btn = $BackButton
@onready var right_btn = $NextButton
@onready var home_btn = $HomeButton

var photos: Array[Texture2D] = []
var idx: int = 0

func _ready() -> void:

	photos = [
		preload("res://assets/ape_relief/welcome_message.png"),
		preload("res://assets/ape_relief/1.png"),
		preload("res://assets/ape_relief/2.png"),
		preload("res://assets/ape_relief/3.png"),
		preload("res://assets/ape_relief/4.png"),
		preload("res://assets/ape_relief/5.png"),
		preload("res://assets/ape_relief/6.png"),
		preload("res://assets/ape_relief/7.png"),
		preload("res://assets/ape_relief/8.png"),
		preload("res://assets/ape_relief/9.png"),
		preload("res://assets/ape_relief/10.png"),
		preload("res://assets/ape_relief/11.png"),
		preload("res://assets/ape_relief/12.png"),
		preload("res://assets/ape_relief/13.png"),
		preload("res://assets/ape_relief/14.png"),
		preload("res://assets/ape_relief/15.png"),
		preload("res://assets/ape_relief/16.png"),
		preload("res://assets/ape_relief/17.png"),
		preload("res://assets/ape_relief/24.png"),
		preload("res://assets/ape_relief/18.png"),
		preload("res://assets/ape_relief/19.png"),
		preload("res://assets/ape_relief/20.png"),
		preload("res://assets/ape_relief/21.png"),
		preload("res://assets/ape_relief/22.png"),
		preload("res://assets/ape_relief/23.png"),
		preload("res://assets/ape_relief/25.png"),
		preload("res://assets/ape_relief/26.png"),
		preload("res://assets/ape_relief/27.png"),
		preload("res://assets/ape_relief/28.png"),
		preload("res://assets/ape_relief/29.png")
	]

	# Setează prima poză
	_show_photo()

	left_btn.pressed.connect(_on_left)
	right_btn.pressed.connect(_on_right)
	home_btn.pressed.connect(_on_home)

func _show_photo() -> void:
	if photos.is_empty():
		image.texture = null
		return
	image.texture = photos[idx]

func _on_left() -> void:
	if photos.is_empty(): return
	idx = (idx - 1 + photos.size()) % photos.size()
	_show_photo()

func _on_right() -> void:
	if photos.is_empty(): return
	idx = (idx + 1) % photos.size()
	_show_photo()

func _on_home() -> void:
	Transition.fade_to_scene("res://scenes/harta.tscn")
