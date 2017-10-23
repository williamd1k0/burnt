extends Node

const SCREEN_CONTROL = 'screen_control'

export(String, FILE, '*.tscn,*.scn') var first_scene
onready var screen = get_node("GameScreen")
onready var fade = get_node("Fade")

func _ready():
	var title = "B U R N T™"
	if '--torrou' in OS.get_cmdline_args():
		title = "TORROU™"
	if '--ds-mode' in OS.get_cmdline_args():
		title += " [DARK SOULS™️]"
	OS.set_window_title(title)
	start_scene(first_scene)

func start_scene(scene, args=null):
	var scene_node = load(scene).instance()
	var control
	screen.add_child(scene_node)
	if scene_node.is_in_group(SCREEN_CONTROL):
		control = scene_node
	else:
		for child in scene_node.get_children():
			if child.is_in_group(SCREEN_CONTROL):
				control = child
				break
	control.connect('scene_change', self, '_on_scene_change')
	fade.fadein()
	yield(fade, 'fadein')
	control.start_scene(args)

func _on_scene_change(scene, args):
	fade.fadeout()
	yield(fade, 'fadeout')
	clear()
	start_scene(scene, args)

func clear():
	if screen.get_child_count() > 0:
		for i in screen.get_children():
			i.queue_free()
