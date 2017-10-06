extends Node

const SCREEN_CONTROL = 'screen_control'

export(String, FILE, '*.tscn,*.scn') var first_scene

func _ready():
	start_scene(first_scene)

func start_scene(scene, args=null):
	var scene_node = load(scene).instance()
	var control
	add_child(scene_node)
	if scene_node.is_in_group(SCREEN_CONTROL):
		control = scene_node
	else:
		for child in scene_node.get_children():
			if child.is_in_group(SCREEN_CONTROL):
				control = child
				break
	control.connect('scene_change', self, '_on_scene_change')
	control.start_scene(args)

func _on_scene_change(scene, args):
	clear() # TODO: fade stuff
	start_scene(scene, args)

func clear():
	if get_child_count() > 0:
		for i in get_children():
			i.queue_free()
