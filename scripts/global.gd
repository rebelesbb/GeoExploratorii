extends Node

const SAVE_PATH := "user://savegame.json"

var sanctuary_level: int = 7
var player_name = ""
var current_level: int = 5
var puzzle_level: int = 0
var animal_flag: bool = true
var max_level_unlocked: int = 0  
var completed_levels: Array = []
var should_animate: bool = false

var quiz_state: Dictionary = {}

var animal_scenes := {
	1: "res://scenes/pages/CaprioaraPage.tscn",
	2: "res://scenes/pages/UrsPage.tscn",
	3: "res://scenes/pages/RataPage.tscn",
	4: "res://scenes/pages/LupPage.tscn",
	5: "res://scenes/pages/OaiePage.tscn",
	6: "res://scenes/pages/CastorPage.tscn",
	7: "res://scenes/pages/CapibaraPage.tscn"
}

# Statistici joc - păstrate în memorie
var game_stats = {
	"total_score": 0.0,
	"history": {}
}

# Funcție pentru a actualiza statisticile
func update_question_stats(q_id: String, is_correct: bool, points_earned: float):
	if not game_stats.history.has(q_id):
		game_stats.history[q_id] = {"attempts": 0, "solved": false}
	
	var stats = game_stats.history[q_id]
	stats["attempts"] += 1
	
	if is_correct:
		stats["solved"] = true
		game_stats["total_score"] += points_earned

# Funcție pentru a reseta statisticile
func reset_game_stats():
	game_stats = {
		"total_score": 0.0,
		"history": {}
	}

func reset_full_game():
	current_level = 0
	max_level_unlocked = 0
	completed_levels = []
	should_animate = false
	quiz_state = {}
	reset_game_stats()
	clear_save()

func save_game() -> void:
	var data := {
		"player_name": player_name,
		"current_level": current_level,
		"max_level_unlocked": max_level_unlocked,
		"completed_levels": completed_levels,
		"should_animate": should_animate,
		"game_stats": game_stats,
		"quiz_state": quiz_state
	}

	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data))
		
func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not f:
		return false

	var parsed = JSON.parse_string(f.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false

	player_name = str(parsed.get("player_name", ""))
	current_level = int(parsed.get("current_level", 0))
	max_level_unlocked = int(parsed.get("max_level_unlocked", 0))
	completed_levels = parsed.get("completed_levels", [])
	should_animate = bool(parsed.get("should_animate", false))

	var gs = parsed.get("game_stats", null)
	if typeof(gs) == TYPE_DICTIONARY:
		game_stats = gs

	var qs = parsed.get("quiz_state", null)
	if typeof(qs) == TYPE_DICTIONARY:
		quiz_state = qs
	else:
		quiz_state = {}

	return true
	
func clear_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
	
	# Android back button 
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_game()
		
	# App in background
	if what == NOTIFICATION_APPLICATION_PAUSED:
		save_game()
		
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		save_game()
	
