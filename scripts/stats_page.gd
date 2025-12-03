extends Control

const QuizDataResource = preload("res://data/quiz_data.gd")

@onready var total_score_label = %ScoreValueLabel
@onready var stats_list = %StatsContainer

func _ready():
	_load_and_display_stats()

func _load_and_display_stats():
	# Folosim direct datele din Global
	var history = Global.game_stats.get("history", {})
	var final_score = round(Global.game_stats.get("total_score", 0.0))
	
	print("Statistici încărcate din Global: Scor = ", final_score, ", Întrebări = ", history.size())
	
	# Animație scor
	var tween = create_tween()
	tween.tween_method(func(val): total_score_label.text = str(val), 0, final_score, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	var quiz_res = QuizDataResource.new()
	var id_to_text_map = {}
	
	for chapter_id in quiz_res.chapters:
		for q in quiz_res.chapters[chapter_id]:
			if "id" in q:
				id_to_text_map[q["id"]] = q["text"]

	# Curăță lista existentă
	for child in stats_list.get_children():
		child.queue_free()

	# Dacă nu sunt date, afișează mesaj
	if history.is_empty():
		var empty_label = Label.new()
		empty_label.text = "Nu ai răspuns încă la nicio întrebare.\nÎncepe jocul pentru a vedea statisticile!"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_label.add_theme_font_size_override("font_size", 20)
		empty_label.add_theme_color_override("font_color", Color("666666"))
		stats_list.add_child(empty_label)
		return

	var questions_by_chapter = {}
	
	for q_id in history.keys():
		var chapter_num = _get_chapter_from_id(q_id)
		if not questions_by_chapter.has(chapter_num):
			questions_by_chapter[chapter_num] = []
		questions_by_chapter[chapter_num].append(q_id)
	
	var sorted_chapters = questions_by_chapter.keys()
	sorted_chapters.sort()
	
	for cap_id in sorted_chapters:
		var cap_title = quiz_res.chapter_titles.get(cap_id, "Capitol " + str(cap_id))
		_create_chapter_header(cap_title)
		
		var q_ids = questions_by_chapter[cap_id]
		q_ids.sort() 
		
		for q_id in q_ids:
			var info = history[q_id]
			var attempts = info.get("attempts", 0)
			var solved = info.get("solved", false)
			
			var q_text = id_to_text_map.get(q_id, "Întrebare necunoscută (" + str(q_id) + ")")
			
			_create_stat_card(q_text, attempts, solved)

func _get_chapter_from_id(q_id: String) -> int:
	if q_id.begins_with("c"):
		var parts = q_id.split("_")
		if parts.size() > 0:
			var cap_str = parts[0].replace("c", "")
			if cap_str.is_valid_int():
				return cap_str.to_int()
	return 99 

func _create_chapter_header(title: String):
	var header_panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color("4466aa") 
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_right = 5
	style.corner_radius_bottom_left = 5
	style.content_margin_left = 15
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	header_panel.add_theme_stylebox_override("panel", style)
	
	var label = Label.new()
	label.text = title
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color.WHITE)
	
	header_panel.add_child(label)
	stats_list.add_child(header_panel)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 5)
	stats_list.add_child(spacer)

func _create_stat_card(text: String, attempts: int, solved: bool):
	var card = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color("ffffff")
	style.shadow_size = 4
	style.shadow_color = Color(0, 0, 0, 0.2)
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 15
	style.content_margin_bottom = 15
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_right = 8
	style.corner_radius_bottom_left = 8
	card.add_theme_stylebox_override("panel", style)
	
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_BEGIN 
	
	var label_text = Label.new()
	label_text.text = text
	label_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label_text.add_theme_color_override("font_color", Color("333333"))
	label_text.add_theme_font_size_override("font_size", 18)
	
	var label_status = Label.new()
	if solved:
		if attempts == 1:
			label_status.text = "Perfect! (1 încercare)"
			label_status.add_theme_color_override("font_color", Color("2ecc71"))
		else:
			label_status.text = "Rezolvat (" + str(attempts) + " încercări)"
			label_status.add_theme_color_override("font_color", Color("f1c40f"))
	else:
		label_status.text = "Greșit / Nerezolvat"
		label_status.add_theme_color_override("font_color", Color("e74c3c"))
	
	label_status.add_theme_font_size_override("font_size", 16)
	label_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label_status.size_flags_horizontal = Control.SIZE_SHRINK_END
	
	hbox.add_child(label_text)
	hbox.add_child(label_status)
	card.add_child(hbox)
	
	stats_list.add_child(card)

func _on_home_button_pressed():
	Transition.fade_to_scene("res://scenes/harta.tscn")
