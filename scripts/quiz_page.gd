# QuizPage.gd
extends Control

const QuizDataResource = preload("res://data/quiz_data.gd")
const PuzzlePiecePage = preload("res://scenes/PuzzlePiecePage.tscn")

const TYPE_MULTI = QuizDataResource.TYPE_MULTI
const TYPE_SINGLE = QuizDataResource.TYPE_SINGLE
const TYPE_TEXT = QuizDataResource.TYPE_TEXT

@onready var background_panel = $BackgroundPanel
@onready var label_level_title = $MarginContainer/VBoxContainer/LevelTitleLabel
@onready var question_label = $MarginContainer/VBoxContainer/QuestionPanel/QuestionLabel
@onready var feedback_label = $MarginContainer/VBoxContainer/FeedbackLabel

@onready var single_container = $MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer
@onready var single_buttons = [
	$MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer/GridContainer/AnswerButton0,
	$MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer/GridContainer/AnswerButton1,
	$MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer/GridContainer/AnswerButton2,
	$MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer/GridContainer/AnswerButton3,
]

@onready var multi_container = $MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer
@onready var multi_checks = [
	$MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/VBoxContainer/MultiCheck0,
	$MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/VBoxContainer/MultiCheck1,
	$MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/VBoxContainer/MultiCheck2,
	$MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/VBoxContainer/MultiCheck3,
]
@onready var multi_check_button = $MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/CheckButton

@onready var text_container = $MarginContainer/VBoxContainer/QuestionTypeRoot/TextAnswerContainer
@onready var text_line_edit = $MarginContainer/VBoxContainer/QuestionTypeRoot/TextAnswerContainer/TextLineEdit
@onready var text_check_button = $MarginContainer/VBoxContainer/QuestionTypeRoot/TextAnswerContainer/CheckButton

var quiz_data_resource : QuizData
var current_chapter_id := 1
var max_chapters := 7

const QUESTIONS_PER_LEVEL = 6 

var selected_questions : Array
var repeat_queue : Array = []
var current_question_index := 0
var is_repeating_phase := false
var current_question_data : Dictionary

var points_per_question : float = 0.0

var style_single := Color("5170ff")
var style_multi := Color("ff914d")
var style_text := Color("df7c99ff")

func _ready():
	quiz_data_resource = QuizDataResource.new()
	current_chapter_id = max(1, Global.current_level)

	var total_questions_in_game = max_chapters * QUESTIONS_PER_LEVEL
	
	if total_questions_in_game > 0:
		points_per_question = 100.0 / float(total_questions_in_game)
	
	print("Valoare per întrebare: ", points_per_question)
	
	_start_level(current_chapter_id)

func _start_level(chapter_id: int):
	selected_questions.clear()
	repeat_queue.clear()
	current_question_index = 0
	is_repeating_phase = false
	
	if not quiz_data_resource.chapters.has(chapter_id):
		print("Eroare: Capitolul ", chapter_id, " nu există în date!")
		return

	var pool = quiz_data_resource.chapters[chapter_id].duplicate()
	
	if pool.size() < QUESTIONS_PER_LEVEL:
		print("Avertisment: Capitolul ", chapter_id, " are mai puțin de 6 întrebări!")
	
	pool.shuffle()
	selected_questions = pool.slice(0, QUESTIONS_PER_LEVEL)
	
	for i in range(selected_questions.size()):
		selected_questions[i]["piece_number"] = i + 1
		
	print("--- ÎNCEPE CAPITOLUL ", chapter_id, " ---")
	_load_question(0)

func _load_question(index: int):
	feedback_label.text = ""
	single_container.visible = false
	multi_container.visible = false
	text_container.visible = false

	if not is_repeating_phase:
		current_question_data = selected_questions[index]
		var title = quiz_data_resource.chapter_titles.get(current_chapter_id, "Capitol " + str(current_chapter_id))
		label_level_title.text = "%s\nÎntrebarea %d din %d" % [title, index + 1, selected_questions.size()]
	else:
		current_question_data = repeat_queue[0]
		label_level_title.text = "Recapitulare greșeli\nRăspunde corect pentru a trece mai departe!"

	var q_id = current_question_data.get("id", "unknown")
	if not Global.game_stats.history.has(q_id):
		Global.game_stats.history[q_id] = {"attempts": 0, "solved": false}

	question_label.text = str(current_question_data["text"])

	match current_question_data["type"]:
		TYPE_SINGLE:
			_background_single()
			_setup_single_choice()
		TYPE_MULTI:
			_background_multi()
			_setup_multi_choice()
		TYPE_TEXT:
			_background_text()
			_setup_text_answer()

func _setup_single_choice():
	single_container.visible = true
	var options = current_question_data["options"]
	for i in range(single_buttons.size()):
		var btn = single_buttons[i]
		for c in btn.get_signal_connection_list("pressed"):
			btn.disconnect("pressed", c["callable"])
		if i < options.size():
			btn.visible = true
			btn.text = options[i]
			btn.pressed.connect(_on_single_answer_pressed.bind(i))
		else:
			btn.visible = false

func _on_single_answer_pressed(chosen_index: int):
	var correct_index = current_question_data["correct_index"]
	_handle_answer_result(chosen_index == correct_index)

func _setup_multi_choice():
	multi_container.visible = true
	var options = current_question_data["options"]
	for i in range(multi_checks.size()):
		multi_checks[i].text = options[i]
		multi_checks[i].button_pressed = false
	for c in multi_check_button.get_signal_connection_list("pressed"):
		multi_check_button.disconnect("pressed", c["callable"])
	multi_check_button.pressed.connect(_on_multi_check_pressed)

func _on_multi_check_pressed():
	var correct_indices = current_question_data["correct_indices"]
	var chosen_indices = []
	for i in range(multi_checks.size()):
		if multi_checks[i].visible and multi_checks[i].button_pressed:
			chosen_indices.append(i)
	
	var is_correct = chosen_indices.size() == correct_indices.size()
	if is_correct:
		for idx in chosen_indices:
			if not correct_indices.has(idx):
				is_correct = false
				break
	_handle_answer_result(is_correct)

func _setup_text_answer():
	text_container.visible = true
	text_line_edit.text = ""
	for c in text_check_button.get_signal_connection_list("pressed"):
		text_check_button.disconnect("pressed", c["callable"])
	text_check_button.pressed.connect(_on_text_check_pressed)

func _on_text_check_pressed():
	var user_answer = text_line_edit.text.strip_edges()
	var correct_answer = str(current_question_data["correct_answer"])
	_handle_answer_result(user_answer.to_lower() == correct_answer.to_lower())

func _handle_answer_result(is_correct: bool):
	_update_statistics(is_correct)
	
	if is_correct:
		var page := PuzzlePiecePage.instantiate()
		add_child(page)
		var question_number = current_question_data["piece_number"]
		var cap = current_chapter_id
		
		print("CAPITOLUL:", cap)
		print("Q_NR:", question_number)
		page.display_puzzle_piece(cap, question_number)
		await page.piece_displayed_and_closed
		
		if is_repeating_phase:
			repeat_queue.pop_front()
			if repeat_queue.is_empty():
				_end_level_check()
			else:
				_load_question(0)
		else:
			current_question_index += 1
			if current_question_index < selected_questions.size():
				_load_question(current_question_index)
			else:
				if repeat_queue.is_empty():
					_end_level_check()
				else:
					is_repeating_phase = true
					_load_question(0)
	else:
		if not repeat_queue.has(current_question_data):
			repeat_queue.append(current_question_data)
		
		if not is_repeating_phase:
			current_question_index += 1
			if current_question_index < selected_questions.size():
				await get_tree().create_timer(1.0).timeout
				_load_question(current_question_index)
			else:
				is_repeating_phase = true
				await get_tree().create_timer(1.0).timeout
				_load_question(0)
		else:
			var failed_q = repeat_queue.pop_front()
			repeat_queue.append(failed_q)
			await get_tree().create_timer(1.0).timeout
			_load_question(0)

func _update_statistics(is_correct: bool):
	var q_id = current_question_data.get("id", "unknown")
	var stats = Global.game_stats.history[q_id]
	
	stats["attempts"] += 1
	
	if is_correct:
		stats["solved"] = true
		
		var points_earned = 0.0
		if stats["attempts"] == 1:
			points_earned = points_per_question
		elif stats["attempts"] == 2:
			points_earned = points_per_question * 0.5
		else:
			points_earned = points_per_question * 0.2
		
		Global.game_stats["total_score"] += points_earned
			
	print("Score: ", round(Global.game_stats["total_score"]), " | Q: ", q_id, " Attempts: ", stats["attempts"])

func _end_level_check():
	Global.current_level = current_chapter_id 
	if not Global.completed_levels.has(current_chapter_id):
		Global.completed_levels.append(current_chapter_id)

	# Întotdeauna mergi la puzzle
	Transition.fade_to_scene("res://scenes/puzzle/PuzzlePage.tscn")

func _background_single():
	var style := StyleBoxFlat.new()
	style.bg_color = style_single
	background_panel.set("theme_override_styles/panel", style)
	
func _background_multi():
	var style := StyleBoxFlat.new()
	style.bg_color = style_multi
	background_panel.set("theme_override_styles/panel", style)
	
func _background_text():
	var style := StyleBoxFlat.new()
	style.bg_color = style_text
	background_panel.set("theme_override_styles/panel", style)
