extends TextureRect

var my_index: int
var connection_map: Dictionary
var snap_thresh: float
var is_dragged: bool = false

# Init
func initialize(idx: int, size_vec: Vector2, map: Dictionary, snap_dist: float):
	my_index = idx
	size = size_vec
	custom_minimum_size = size_vec
	connection_map = map
	snap_thresh = snap_dist
	
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	mouse_filter = Control.MOUSE_FILTER_STOP 
	set_process(true)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragged = true
			var root = _get_root_piece()
			root.move_to_front()
		else:
			is_dragged = false
			_try_snap_to_neighbor()

func _process(_delta):
	if is_dragged:
		var root = _get_root_piece()
		
		var mouse_pos = get_global_mouse_position()
		
		var group_offset = global_position - root.global_position
		
		root.global_position = mouse_pos - group_offset - (size / 2)

func _try_snap_to_neighbor():
	var manager = _find_manager()
	if not manager: return

	var all_pieces = manager.get_all_pieces_reference()
	var my_root = _get_root_piece()

	for other_piece in all_pieces:
		var other_root = other_piece._get_root_piece()
		if other_root == my_root:
			continue


		if connection_map.get(my_index, {}).get("right") == other_piece.my_index:
			var target_pos = global_position + Vector2(size.x, 0)
			if other_piece.global_position.distance_to(target_pos) < snap_thresh:
				_perform_snap(my_root, other_root, target_pos - other_piece.global_position)
				return

		if connection_map.get(my_index, {}).get("bottom") == other_piece.my_index:
			var target_pos = global_position + Vector2(0, size.y)
			if other_piece.global_position.distance_to(target_pos) < snap_thresh:
				_perform_snap(my_root, other_root, target_pos - other_piece.global_position)
				return

		if connection_map.get(other_piece.my_index, {}).get("right") == my_index:
			var target_pos = other_piece.global_position + Vector2(size.x, 0)
			if global_position.distance_to(target_pos) < snap_thresh:
				_perform_snap(my_root, other_root, target_pos - global_position, true)
				return

		if connection_map.get(other_piece.my_index, {}).get("bottom") == my_index:
			var target_pos = other_piece.global_position + Vector2(0, size.y)
			if global_position.distance_to(target_pos) < snap_thresh:
				_perform_snap(my_root, other_root, target_pos - global_position, true)
				return

func _perform_snap(my_root_node, other_root_node, move_vec: Vector2, move_self: bool = false):
	var child_group = my_root_node
	var parent_group = other_root_node
	
	if move_self:
		child_group.global_position += move_vec
	else:
		child_group.global_position -= move_vec 
		
	is_dragged = false
	
	var saved_global_pos = child_group.global_position
	child_group.get_parent().remove_child(child_group)
	parent_group.add_child(child_group)
	child_group.global_position = saved_global_pos
	
	var manager = _find_manager()
	if manager:
		manager.check_win_condition()

func _get_root_piece() -> TextureRect:
	var root = self
	while root.get_parent() is TextureRect:
		root = root.get_parent()
	return root

func _find_manager():
	var node = self
	while node and not node.has_method("get_all_pieces_reference"):
		node = node.get_parent()
	return node
