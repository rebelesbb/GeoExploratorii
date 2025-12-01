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
