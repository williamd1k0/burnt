extends Sprite

const MINI_TOAST = preload('./toasts/MiniToast.tscn')
export(bool) var torrou_mode = false
var toast_count = 1
var has_joy = false

func _ready():
	ToastSpawner.connect('spawned', self, '_on_spawned')
	has_joy = not Input.get_connected_joysticks().empty()
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	set_process(torrou_mode)

func _process(delta):
	if Input.is_action_pressed("left-hand"):
		translate(Vector2(-delta*40, 0))
	elif Input.is_action_pressed("right-hand"):
		translate(Vector2(delta*40, 0))

func _on_spawned(toast):
	var toast_node = MINI_TOAST.instance()
	toast_node.toast = toast
	get_node("Toasts%s" % toast_count).add_child(toast_node)
	toast_count *= -1 # this is ugly, i know
	get_node("AnimationPlayer").play("spawn")
	if has_joy:
		Input.start_joy_vibration(0, 1, 1, 0.1)

func _on_joy_connection_changed(device_id, connected):
	if device_id == 0:
		has_joy = connected
