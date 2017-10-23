extends Sprite

signal dead

const MINI_TOAST = preload('./toasts/MiniToast.tscn')
const TOASTS = ['common', 'jam', 'burnt']
export(bool) var torrou_mode = false
var toast_count = [1, 2]
var has_joy = false
var speed = 60

func _ready():
	has_joy = not Input.get_connected_joysticks().empty()
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	if torrou_mode:
		set_torrou(true)
		get_node("HitBox").connect("area_enter", self, "_on_area_enter")
	if get_parent() == get_tree().get_root():
		_main()

func _main():
	if not torrou_mode:
		var ToastSpawner = preload('res://game/items/gameplay/ToastSpawner.tscn').instance()
		add_child(ToastSpawner)
		ToastSpawner.connect('spawned', self, 'spawn_toast')
		ToastSpawner.start()
	set_pos(Vector2(32, 32))

func _process(delta):
	var movement = get_pos()
	if Input.is_action_pressed("left-hand"):
		movement.x -= delta*speed
	elif Input.is_action_pressed("right-hand"):
		movement.x += delta*speed
	movement.x = clamp(movement.x, 0, 64)
	set_pos(movement)

func _input(event):
	if event.is_action_pressed("shoot"):
		spawn_toast(TOASTS[randi() % TOASTS.size()])

func set_torrou(b):
	set_process(b)
	set_process_input(b)

func spawn_toast(toast):
	var toast_node = MINI_TOAST.instance()
	toast_node.toast = toast
	toast_node.set_z(toast_count[0]-1)
	toast_node.set_global_pos(
		get_node("Layers/Toasts%s" % toast_count[0]).get_global_pos()
	)
	get_node("Layers/Toasts%s/Node" % toast_count[0]).add_child(toast_node)
	if torrou_mode:
		toast_node.shoot()
	toast_count.invert()
	get_node("AnimationPlayer").play("spawn")
	if has_joy:
		Input.start_joy_vibration(0, 1, 1, 0.1)

func _on_area_enter(area):
	if area.is_in_group('toast'):
		emit_signal("dead")

func _on_joy_connection_changed(device_id, connected):
	if device_id == 0:
		has_joy = connected
