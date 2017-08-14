extends Node

signal spawned(toast)

const TOASTS = [
	'common',
	'jam',
	'burnt'
]

const TOASTS_NODES = {
	'common': preload('res://game/items/toasts/Toast.tscn'),
	'jam': preload('res://game/items/toasts/ToastJam.tscn'),
	'burnt': preload('res://game/items/toasts/ToastBurnt.tscn')
}

export(float) var interval = 0.5
export(bool) var auto_start = false
var enabled = false
var difficulty

func _ready():
	#connect('spawned', self, '_on_spawned')
	if auto_start:
		start()

func start(interval_=null):
	if interval_ != null:
		interval = interval_
	enabled = true
	spawn()

func stop():
	enabled = false
	get_node("Timer").stop()

func spawn():
	var idx = randi() % TOASTS.size()
	emit_signal('spawned', TOASTS[idx])
	get_node("Timer").set_wait_time(interval)
	get_node("Timer").start()

func _on_Timer_timeout():
	if enabled:
		spawn()

func _on_spawned(toast):
	prints('SPAWNED:', toast)
