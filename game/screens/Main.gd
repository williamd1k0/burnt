extends Node

const SCREEN_CONTROL = 'screen_control'

export(String, FILE, '*.tscn,*.scn') var first_scene
onready var screen = get_node("GameScreen")
onready var fade = get_node("Fade")

func _ready():
	start_game()
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("restart"):
		clear()
		start_game()
	elif event.is_action_pressed("torrou"):
		GameMode.mode ^= GameMode.TORROU
	elif event.is_action_pressed("dark_souls"):
		GameMode.mode ^= GameMode.DARK_SOULS

func start_game():
	var title = "B U R N T™"
	if GameMode.is_torrou():
		title = "TORROU™"
	if GameMode.is_dark_souls():
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
