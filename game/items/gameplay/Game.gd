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

export(String, \
	'easy', 'normal', 'hard' \
) var difficulty = 'easy'

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

onready var spawner = get_node("ToastSpawner")

func _ready():
	spawner.connect("spawned", get_node("Toaster"), "spawn_toast")
	spawner.connect("spawned", get_node("Spawner"), "spawn_toast")
	for hand in get_node("Hands").get_children():
		hand.connect("miss", self, "miss")
		hand.connect("toasted", self, "toasted")
	if get_parent() == get_tree().get_root():
		_main()

func _main():
	print('DEBUG GAME')
	start()

func start(diff=null):
	if diff != null:
		difficulty = diff
	for toast in get_tree().get_nodes_in_group('toast'):
		toast.free()
	spawner.start(
		DIFFICULTY[difficulty]['interval'],
		DIFFICULTY[difficulty]['speedup']
	)
	for hand in get_node("Hands").get_children():
		hand.enabled = true
		hand.toast_cache.clear()

func stop():
	spawner.stop()

func toasted(type):
	prints('TOASTED', type)
	if type == TOAST_BURNT:
		gameover(GAMEOVER_BURNT)
	else:
		emit_signal('toasted', type)

func miss(type):
	prints('MISS', type)
	if type != TOAST_BURNT:
		if type in DIFFICULTY[difficulty]['required']:
			gameover(GAMEOVER_MISS)

func gameover(by):
	stop()
	for hand in get_node("Hands").get_children():
		hand.enabled = false
	emit_signal('gameover', by)

func _on_AnimationPlayer_finished():
	if get_node("AnimationPlayer").get_current_animation() == 'start':
		emit_signal("ready")
