extends Node

const SAVE_PATH = 'user://highscores-1.0'
var file = File.new()
var high_scores = {
	'easy': 0,
	'normal': 0,
	'hard': 0
}

func _ready():
	if file.file_exists(SAVE_PATH):
		load_highscores()
	else:
		save_highscores()

func save_highscores():
	file.open(SAVE_PATH, File.WRITE)
	file.store_var(high_scores)
	file.close()

func load_highscores():
	file.open(SAVE_PATH, File.READ)
	high_scores = file.get_var()
	file.close()

func is_highscore(diff, score):
	return high_scores[diff] < score

func new_score(diff, score):
	if is_highscore(diff, score):
		high_scores[diff] = score
		save_highscores()

func get_score(diff):
	return high_scores[diff]
