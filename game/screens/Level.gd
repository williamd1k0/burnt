extends Node

signal menu

export(bool) var auto_start = false
export(String, 'easy', 'normal', 'hard') var difficulty
export(bool) var ds_mode = false

const POINTS = [
	1, # 0: common
	2, # 1: jam
]

var score = 0
var playing = false

func _ready():
	if ToastSpawner.difficulty != null:
		difficulty = ToastSpawner.difficulty

func _input(event):
	if event.is_action_pressed('pause') and playing:
		get_node("ui/Pause").set_hidden(get_tree().is_paused())
		get_tree().set_pause(not get_tree().is_paused())

func start():
	playing = true
	get_node("Game").start(difficulty)

func replay():
	score = 0
	get_node("AnimationPlayer").play("play")
	start()

func _on_Game_toasted( type ):
	score += POINTS[type]
	get_node("ui/Total").set_text(str(score))

func _on_Game_gameover( by ):
	if not playing:
		return
	playing = false
	LocalScore.new_score(difficulty, score)
	get_node("Game").stop()
	if ds_mode:
		get_node("ui/DsMode").you_died()
	else:
		get_node("AnimationPlayer").play("gameover")

func _on_Game_ready():
	if auto_start:
		start()
	set_process_input(true)

func _on_Play_pressed():
	replay()

func _on_Menu_pressed():
	emit_signal('menu')
