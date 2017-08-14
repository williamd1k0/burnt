tool
extends Sprite

signal toasted(type)
signal miss(type)

export(String, 'none', 'left', 'right') var hand setget _set_hand
var open = false
var toast_cache = []
var enabled = true

func _ready():
	if not get_tree().is_editor_hint():
		set_process_input(true)
		set_process(true)

func _process(delta):
	if open and not toast_cache.empty() and is_visible():
		for toast in toast_cache:
			print(toast)
			toast_cache.remove(toast_cache.find(toast))
			var type = toast.toasted()
			emit_signal('toasted', type)

func _set_hand(side):
	hand = side
	if side == 'right':
		set_scale(Vector2(-1, 1))
	elif side == 'left':
		set_scale(Vector2(1, 1))
	else:
		set_scale(Vector2(0, 0))

func set_open(val):
	if val != open:
		open = val
		if open:
			get_node("anim").play("open")
		else:
			get_node("anim").play("close")

func can_move():
	return is_visible() and enabled

func _on_Area2D_area_enter(area):
	if area.is_in_group('toast') and can_move():
		print('TOASTED')
		toast_cache.append(area)

func _on_Area2D_area_exit( area ):
	if area in toast_cache and can_move():
		toast_cache.remove(toast_cache.find(area))
		emit_signal('miss', area.type)

func _input(event):
	if event.is_action("%s-hand" % hand) and can_move():
		set_open(event.is_pressed())

func _on_input_event( viewport, event, shape_idx ):
	if event.type in [InputEvent.MOUSE_BUTTON, InputEvent.SCREEN_TOUCH]:
		set_open(event.is_pressed())
