extends Node2D

enum {
	TOAST_COMMON,
	TOAST_JAM,
	TOAST_BURNT
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
	#spawner.connect("spawned", get_node("Toaster"), "spawn_toast")
	spawner.connect("spawned", get_node("Spawner"), "spawn_toast")
	get_node("Spawner").connect("toasted", self, "toasted")
	get_node("Toaster").connect("dead", self, "gameover", [null])
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
	get_node("Toaster").set_torrou(true)

func stop():
	get_node("Toaster").set_torrou(false)
	spawner.stop()

func toasted(type):
	prints('TOASTED', type)
	emit_signal('toasted', type)

func gameover(by):
	stop()
	emit_signal('gameover', by)

func _on_AnimationPlayer_finished():
	if get_node("AnimationPlayer").get_current_animation() == 'start':
		emit_signal("ready")
