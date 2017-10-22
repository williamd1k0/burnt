extends Node

signal spawned(toast)

const TOASTS = [
	'common',
	'jam',
	'burnt'
]

export(float) var interval = 0.5
export(FloatArray) var speed_up = FloatArray([10, 0.5])
export(bool) var auto_start = false
var enabled = false

func _ready():
	#connect('spawned', self, '_on_spawned')
	if auto_start:
		start()

func start(interval_=null, speedup=null):
	if interval_ != null:
		interval = interval_
	if speedup != null:
		speed_up = speedup
	enabled = true
	spawn()
	get_node("Timer2").set_wait_time(speed_up[0])
	get_node("Timer2").start()

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


func _on_Timer2_timeout():
	interval = max(speed_up[1], interval-0.05)
