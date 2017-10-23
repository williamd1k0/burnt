extends Node

signal scene_start(args)
signal scene_change(scene, args)

export(String, FILE, '*.tscn,*.scn') var next_scene
export(bool) var kill_ = false setget _set_kill
var args
var next_args


func change_scene(nextscene=null, nextargs=null):
	if nextscene == null:
		nextscene = next_scene
	if nextargs == null:
		nextargs = next_args
	emit_signal("scene_change", nextscene, nextargs)
	if not get_tree().has_group('main_scene'):
		print('THERE IS NO MAIN SCENE')
		get_tree().change_scene(nextscene)

func next_scene(nextargs=null):
	change_scene(next_scene, nextargs)

func _set_kill(val):
	if val:
		kill()

func kill():
	change_scene()

func start_scene(args_=null):
	args = args_
	emit_signal("scene_start", args_)
