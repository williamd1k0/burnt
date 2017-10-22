extends Node2D

export(String, \
	'easy', 'normal', 'hard' \
) var difficulty
export(bool) var ds_mode = false

const POINTS = [
	1, # 0: common
	2, # 1: jam
]

var score = 0
var playing = false

func _ready():
	if get_parent() == get_tree().get_root():
		_main()
	
func _main():
	print('DEBUG LEVEL')
	start()

func _input(event):
	if event.is_action_pressed('pause') and playing:
		get_node("ui/Pause").set_hidden(get_tree().is_paused())
		get_tree().set_pause(not get_tree().is_paused())

func start():
	prints('START', difficulty)
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
		get_node("ui/GameOver/Diff").set_text(difficulty)
		get_node("ui/GameOver/Highscore").set_text(str(LocalScore.get_score(difficulty)))
		get_node("AnimationPlayer").play("gameover")

func _on_Play_pressed():
	replay()

func _on_Menu_pressed():
	get_node("ScreenControl").kill()

func _on_ScreenControl_scene_start( args ):
	difficulty = args
	start()
	set_process_input(true)
