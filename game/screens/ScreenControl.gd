extends Node

signal scene_start(args)
signal scene_change(scene, args)

export(String) var next_scene
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

func next_scene(nextargs=null):
	change_scene(next_scene, nextargs)

func kill():
	change_scene()

func start_scene(args_=null):
	args = args_
	emit_signal("scene_start", args_)
