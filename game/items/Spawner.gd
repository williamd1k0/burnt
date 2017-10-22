extends Node2D

export(PackedScene) var toast_follow
const SIDES = {
	-1: 0,
	1: 1
}
const TOASTS_NODES = {
	'common': preload('res://game/items/toasts/Toast.tscn'),
	'jam': preload('res://game/items/toasts/ToastJam.tscn'),
	'burnt': preload('res://game/items/toasts/ToastBurnt.tscn')
}

var side = 1

func _ready():
	if get_parent() == get_tree().get_root():
		_main()

func _main():
	var ToastSpawner = preload('res://game/items/gameplay/ToastSpawner.tscn').instance()
	add_child(ToastSpawner)
	ToastSpawner.connect('spawned', self, 'spawn_toast')
	ToastSpawner.start()

func spawn_toast(toast_name):
	var side_node = get_node("Paths").get_child(SIDES[side])
	var rand = randi() % side_node.get_child_count()
	var follow = toast_follow.instance()
	side_node.get_child(rand).add_child(follow)
	var toast = TOASTS_NODES[toast_name].instance()
	follow.spawn_toast(toast)
	side *= -1
