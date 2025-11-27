# quiz_data.gd
extends Resource
class_name QuizData

const TYPE_MULTI = "multi"
const TYPE_SINGLE = "single"
const TYPE_TEXT = "text"

var questions := [
	{
		"type": TYPE_SINGLE,
		"text": "Care este capitala României?",
		"options": ["Cluj-Napoca", "Iași", "București", "Timișoara"],
		"correct_index": 2
	},
	{
		"type": TYPE_MULTI,
		"text": "Care dintre următoarele sunt țări din Europa?",
		"options": ["Spania", "Brazilia", "Germania", "China"],
		"correct_indices": [0, 2]
	},
	{
		"type": TYPE_TEXT,
		"text": "Capitala Franței este ______.",
		"correct_answer": "Paris"
	},
	{
		"type": TYPE_SINGLE,
		"text": "Care este capitala României?",
		"options": ["Cluj-Napoca", "Iași", "București", "Timișoara"],
		"correct_index": 2
	},
	{
		"type": TYPE_MULTI,
		"text": "Care dintre următoarele sunt țări din Europa?",
		"options": ["Spania", "Brazilia", "Germania", "China"],
		"correct_indices": [0, 2]
	},
	{
		"type": TYPE_TEXT,
		"text": "Capitala Franței este ______.",
		"correct_answer": "Paris"
	},
	{
		"type": TYPE_SINGLE,
		"text": "Care este capitala României?",
		"options": ["Cluj-Napoca", "Iași", "București", "Timișoara"],
		"correct_index": 2
	},
	{
		"type": TYPE_MULTI,
		"text": "Care dintre următoarele sunt țări din Europa?",
		"options": ["Spania", "Brazilia", "Germania", "China"],
		"correct_indices": [0, 2]
	},
	{
		"type": TYPE_TEXT,
		"text": "Capitala Franței este ______.",
		"correct_answer": "Paris"
	},
	{
		"type": TYPE_SINGLE,
		"text": "Care este capitala României?",
		"options": ["Cluj-Napoca", "Iași", "București", "Timișoara"],
		"correct_index": 2
	},
	{
		"type": TYPE_MULTI,
		"text": "Care dintre următoarele sunt țări din Europa?",
		"options": ["Spania", "Brazilia", "Germania", "China"],
		"correct_indices": [0, 2]
	},
	{
		"type": TYPE_TEXT,
		"text": "Capitala Franței este ______.",
		"correct_answer": "Paris"
	},
	# ... completezi până la 10 întrebări
]
