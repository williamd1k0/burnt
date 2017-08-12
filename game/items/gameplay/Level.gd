extends Node

export(bool) var auto_start = false
export(String, 'easy', 'average', 'hard') var difficult
export(bool) var ds_mode = false

const POINTS = [
	1, # 0: common
	2, # 1: jam
]

var score = 0
var playing = false

func _ready():
	if auto_start:
		start()

func start():
	playing = true
	get_node("Game").start(difficult)

func _on_Game_toasted( type ):
	score += POINTS[type]
	get_node("ui/Total").set_text(str(score))

func _on_Game_gameover( by ):
	if not playing:
		return
	playing = false
	get_node("Game").stop()
	if ds_mode:
		get_node("ui/DsMode").you_died()
	else:
		get_node("ui/GameOver").show()

