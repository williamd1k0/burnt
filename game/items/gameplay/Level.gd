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
	pass

func _input(event):
	if event.is_action_pressed('pause') and playing:
		get_node("ui/Pause").set_hidden(get_tree().is_paused())
		get_tree().set_pause(not get_tree().is_paused())
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.doubleclick:
			OS.set_window_size(OS.get_window_size()*2)

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

func _on_Game_ready():
	if auto_start:
		start()
	set_process_input(true)
