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

signal toasted(type)
signal gameover(by)

export(bool) var auto_start = false
export(String, 'easy', 'average', 'hard') var difficult
const DIFFICULT = {
	'easy': {
		'interval': 1,
		'required': []
	},
	'average': {
		'interval': 0.7,
		'required': [TOAST_COMMON]
	},
	'hard': {
		'interval': 0.5,
		'required': [TOAST_COMMON, TOAST_JAM]
	}
}

func _ready():
	if auto_start:
		start()

func start(diff=null):
	if diff != null:
		difficult = diff
	ToastSpawner.start(DIFFICULT[difficult]['interval'])

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
		if type in DIFFICULT[difficult]['required']:
			emit_signal('gameover', GAMEOVER_MISS)

func _on_LeftHand_toasted( type ):
	toasted(type)

func _on_RightHand_toasted( type ):
	toasted(type)


func _on_LeftHand_miss( type ):
	miss(type)

func _on_RightHand_miss( type ):
	miss(type)
