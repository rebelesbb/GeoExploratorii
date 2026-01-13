extends Node2D

@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	music.volume_db = -25 
	if not music.playing:
		music.play()

func set_enabled(enabled: bool) -> void:
	var idx := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(idx, not enabled)

func is_enabled() -> bool:
	var idx := AudioServer.get_bus_index("Music")
	return not AudioServer.is_bus_mute(idx)
