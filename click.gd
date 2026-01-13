extends Node2D

@onready var click = $AudioStreamPlayer2D  

func _ready() -> void:
	hook_all_buttons()
	get_tree().node_added.connect(_on_node_added)

func play_click() -> void:
	click.stop()
	click.play()

func hook_all_buttons(root: Node = null) -> void:
	if root == null:
		root = get_tree().root

	for n in _get_all_nodes(root):
		if n is BaseButton:
			if not n.pressed.is_connected(play_click):
				n.pressed.connect(play_click)

func _on_node_added(n: Node) -> void:
	if n is BaseButton:
		if not n.pressed.is_connected(play_click):
			n.pressed.connect(play_click)

func _get_all_nodes(node: Node) -> Array:
	var arr: Array = [node]
	for c in node.get_children():
		arr += _get_all_nodes(c)
	return arr
	
func set_enabled(enabled: bool) -> void:	
	var idx := AudioServer.get_bus_index("click")
	AudioServer.set_bus_mute(idx, not enabled)

func is_enabled() -> bool:
	var idx := AudioServer.get_bus_index("click")
	return not AudioServer.is_bus_mute(idx)
