extends Node

var sanctuary_level: int = 7
var player_name = ""
var current_level: int = 0       
var max_level_unlocked: int = 0  
var completed_levels: Array = []

var animal_scenes := {
	1: "res://scenes/pages/CaprioaraPage.tscn",
	2: "res://scenes/pages/LupPage.tscn",
	3: "res://scenes/pages/OaiePage.tscn",
	4: "res://scenes/pages/RataPage.tscn",
	5: "res://scenes/pages/UrsPage.tscn",
	6: "res://scenes/pages/CapibaraPage.tscn"
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
