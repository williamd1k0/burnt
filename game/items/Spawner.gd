extends Node2D

export(PackedScene) var toast_follow
const SIDES = {
	-1: 0,
	1: 1
}
var side = 1

func _ready():
	ToastSpawner.connect('spawned', self, 'spawn_toast')

func spawn_toast(toast_name):
	var side_node = get_node("Paths").get_child(SIDES[side])
	var rand = randi() % side_node.get_child_count()
	var follow = toast_follow.instance()
	side_node.get_child(rand).add_child(follow)
	var toast = ToastSpawner.TOASTS_NODES[toast_name].instance()
	follow.spawn_toast(toast)
	side *= -1
