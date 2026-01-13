extends CanvasLayer

@onready var overlay: ColorRect = $Overlay

var is_transitioning: bool = false

func fade_to_scene(scene_path: String, duration: float = 0.5) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	overlay.visible = true
	overlay.modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, duration)
	tween.finished.connect(func():
		get_tree().change_scene_to_file(scene_path)
		_fade_in(duration)
	)

func _fade_in(duration: float) -> void:
	overlay.modulate.a = 1.0
	var tween: Tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 0.0, duration)
	tween.finished.connect(func():
		overlay.visible = false
		is_transitioning = false
	)

func fade_and_quit(duration: float = 0.5) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	overlay.visible = true
	overlay.modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, duration)
	tween.finished.connect(func():
		get_tree().quit()
	)
	
