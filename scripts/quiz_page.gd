# QuizPage.gd
extends Control

const QuizDataResource = preload("res://data/quiz_data.gd")

# tipuri întrebări
const TYPE_MULTI = QuizDataResource.TYPE_MULTI
const TYPE_SINGLE = QuizDataResource.TYPE_SINGLE
const TYPE_TEXT = QuizDataResource.TYPE_TEXT

@onready var background_panel = $BackgroundPanel

@onready var label_level_title = $MarginContainer/VBoxContainer/LevelTitleLabel
@onready var question_label = $MarginContainer/VBoxContainer/QuestionPanel/QuestionLabel

@onready var single_container = $MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer
@onready var single_buttons = []

@onready var multi_container = $MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer
@onready var multi_checks = []
@onready var multi_check_button = $MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/CheckButton


@onready var text_container = $MarginContainer/VBoxContainer/QuestionTypeRoot/TextAnswerContainer
@onready var text_line_edit = $MarginContainer/VBoxContainer/QuestionTypeRoot/TextAnswerContainer/TextLineEdit
@onready var text_check_button = $MarginContainer/VBoxContainer/QuestionTypeRoot/TextAnswerContainer/CheckButton

@onready var feedback_label = $MarginContainer/VBoxContainer/FeedbackLabel

var all_questions : Array
var selected_questions : Array      # cele 6 întrebări unice
var repeat_queue : Array = []       # întrebările greșite care revin la final
var current_question_index := 0     # index în selected_questions
var is_repeating_phase := false     # dacă am terminat cele 6 și repetăm
var current_question_data           # întrebarea curentă

var style_single := Color("5170ff")  # verde pal
var style_multi := Color("ff914d")   
var style_text := Color("df7c99ff")    # galben pal

func _ready():
	print("Ready!")
	print("all_questions: ", all_questions)
	print("selected: ", selected_questions)

	all_questions = QuizDataResource.new().questions
	
	single_buttons = [
		$MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer/GridContainer/AnswerButton0,
		$MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer/GridContainer/AnswerButton1,
		$MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer/GridContainer/AnswerButton2,
		$MarginContainer/VBoxContainer/QuestionTypeRoot/SingleChoiceContainer/GridContainer/AnswerButton3,
	]
	
	multi_checks = [
		$MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/VBoxContainer/MultiCheck0,
		$MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/VBoxContainer/MultiCheck1,
		$MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/VBoxContainer/MultiCheck2,
		$MarginContainer/VBoxContainer/QuestionTypeRoot/MultiChoiceContainer/VBoxContainer/MultiCheck3,
	]
	
	_pick_random_questions()
	_load_question(0)

func _pick_random_questions():
	var tmp = all_questions.duplicate()
	tmp.shuffle()
	selected_questions = tmp.slice(0, 6)

func _load_question(index: int):
	feedback_label.text = ""
	single_container.visible = false
	multi_container.visible = false
	text_container.visible = false

	if not is_repeating_phase:
		# suntem în faza inițială 1–6
		current_question_data = selected_questions[index]
		label_level_title.text = "Întrebarea %d din 6" % (index + 1)
	else:
		# luăm prima întrebare din coadă
		current_question_data = repeat_queue[0]
		label_level_title.text = "Repetiție – răspunde corect!"

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

# ---------- SINGLE CHOICE ----------
func _setup_single_choice():
	single_container.visible = true
	var options = current_question_data["options"]

	for i in range(single_buttons.size()):
		var btn = single_buttons[i]

		# CLEAN SIGNALS FIRST
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
	var is_correct = chosen_index == correct_index
	_handle_answer_result(is_correct)

# ---------- MULTI CHOICE ----------
func _setup_multi_choice():
	multi_container.visible = true
	var options = current_question_data["options"]

	for i in range(multi_checks.size()):
		var chk = multi_checks[i]
		chk.text = options[i]
		chk.button_pressed = false

	for c in multi_check_button.get_signal_connection_list("pressed"):
		multi_check_button.disconnect("pressed", c["callable"])

	multi_check_button.pressed.connect(_on_multi_check_pressed)


func _on_multi_check_pressed():
	var correct_indices : Array = current_question_data["correct_indices"]
	var chosen_indices : Array = []

	for i in range(multi_checks.size()):
		if multi_checks[i].visible and multi_checks[i].button_pressed:
			chosen_indices.append(i)

	# corect dacă:
	# - numărul de răspunsuri bifate = numărul de răspunsuri corecte
	# - și fiecare index este în lista celor corecte
	var is_correct = chosen_indices.size() == correct_indices.size()
	if is_correct:
		for idx in chosen_indices:
			if not correct_indices.has(idx):
				is_correct = false
				break

	_handle_answer_result(is_correct)

# ---------- TEXT ANSWER ----------
func _setup_text_answer():
	text_container.visible = true
	text_line_edit.text = ""
	for c in text_check_button.get_signal_connection_list("pressed"):
		text_check_button.disconnect("pressed", c["callable"])
	text_check_button.pressed.connect(_on_text_check_pressed)

func _on_text_check_pressed():
	var user_answer = text_line_edit.text.strip_edges()
	var correct_answer = str(current_question_data["correct_answer"])
	var is_correct = user_answer.to_lower() == correct_answer.to_lower()
	_handle_answer_result(is_correct)

# ---------- LOGICA GENERALĂ ----------
func _handle_answer_result(is_correct: bool):
	if is_correct:
		feedback_label.text = "Bravo! Răspuns corect! 🎉"
		if is_repeating_phase:
			# scoatem întrebarea din coada de repetări
			repeat_queue.pop_front()
			if repeat_queue.is_empty():
				_end_quiz()
			else:
				# următoarea întrebare greșită
				await get_tree().create_timer(1.0).timeout
				_load_question(0) # index ignorat în faza de repetare
		else:
			# faza 1–6
			current_question_index += 1
			if current_question_index < 6:
				await get_tree().create_timer(1.0).timeout
				_load_question(current_question_index)
			else:
				# am terminat cele 6 întrebări, trecem la repetări
				if repeat_queue.is_empty():
					_end_quiz()
				else:
					is_repeating_phase = true
					await get_tree().create_timer(1.0).timeout
					_load_question(0)
	else:
		feedback_label.text = "Mai încearcă! Răspuns greșit."
		# adăugăm întrebarea în coadă doar o dată
		if not repeat_queue.has(current_question_data):
			repeat_queue.append(current_question_data)

		if is_repeating_phase:
			# în faza de repetare, copilul va revedea întrebarea până o face corect.
			pass
		else:
			# în faza 1–6, trecem la următoarea întrebare
			current_question_index += 1
			if current_question_index < 6:
				await get_tree().create_timer(1.0).timeout
				_load_question(current_question_index)
			else:
				# am terminat cele 6, intrăm în faza de repetări
				if repeat_queue.is_empty():
					_end_quiz()
				else:
					is_repeating_phase = true
					await get_tree().create_timer(1.0).timeout
					_load_question(0)

func _end_quiz():
	feedback_label.text = "Felicitări! Ai terminat nivelul! 🏆"
	# aici poți:
	# - să schimbi scena la un ecran de rezultat
	# - să trimiți semnal către un manager global
	# get_tree().change_scene_to_file("res://scenes/LevelComplete.tscn")

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
