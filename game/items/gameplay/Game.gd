extends Node2D

enum {
	TOAST_COMMON,
	TOAST_JAM,
	TOAST_BURNT
}

enum {
	GAMEOVER_BURNT,
	GAMEOVER_MISS
}

signal ready
signal toasted(type)
signal gameover(by)

export(bool) var auto_start = false
export(String, 'easy', 'normal', 'hard') var difficulty = 'easy'
const DIFFICULTY = {
	'easy': {
		'interval': 0.5,
		'speedup': [10, 0.3],
		'required': []
	},
	'normal': {
		'interval': 0.4,
		'speedup': [9, 0.2],
		'required': [TOAST_COMMON]
	},
	'hard': {
		'interval': 0.2,
		'speedup': [8, 0.1],
		'required': [TOAST_COMMON, TOAST_JAM]
	}
}

func _ready():
	connect('gameover', self, '_on_gameover')
	if auto_start:
		start()

func start(diff=null):
	if diff != null:
		difficulty = diff
	for toast in get_tree().get_nodes_in_group('toast'):
		toast.free()
	ToastSpawner.start(
		DIFFICULTY[difficulty]['interval'],
		DIFFICULTY[difficulty]['speedup']
	)
	for hand in get_node("Hands").get_children():
		hand.enabled = true
		hand.toast_cache.clear()

func stop():
	ToastSpawner.stop()

func toasted(type):
	prints('TOASTED', type)
	if type == TOAST_BURNT:
		emit_signal('gameover', GAMEOVER_BURNT)
	else:
		emit_signal('toasted', type)

func miss(type):
	prints('MISSED', type)
	if type != TOAST_BURNT:
		if type in DIFFICULTY[difficulty]['required']:
			emit_signal('gameover', GAMEOVER_MISS)

func _on_LeftHand_toasted( type ):
	toasted(type)

func _on_RightHand_toasted( type ):
	toasted(type)


func _on_LeftHand_miss( type ):
	miss(type)

func _on_RightHand_miss( type ):
	miss(type)

func _on_AnimationPlayer_finished():
	if get_node("AnimationPlayer").get_current_animation() == 'start':
		emit_signal("ready")

func _on_gameover(by):
	for hand in get_node("Hands").get_children():
		hand.enabled = false
