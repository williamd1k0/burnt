tool
extends Sprite

signal toasted(type)
signal miss(type)

export(String, \
	'none', 'left', 'right' \
) var hand setget _set_hand

var open = false
var touching = false
var toast_cache = []
var enabled = true

func _ready():
	if not get_tree().is_editor_hint():
		set_process_input(true)
		set_process(true)

func _process(delta):
	if Input.is_action_pressed("%s-hand" % hand) and can_move():
		set_open(true)
	elif can_move() and not touching:
		set_open(false)
	if open and not toast_cache.empty() and is_visible():
		for toast in toast_cache:
			toast_cache.remove(toast_cache.find(toast))
			var type = toast.toasted()
			emit_signal('toasted', type)
			get_node("Sfx").play("toasted")

func _set_hand(side):
	hand = side
	if side == 'right':
		set_scale(Vector2(-1, 1))
	elif side == 'left':
		set_scale(Vector2(1, 1))
	else:
		set_scale(Vector2(0, 0))

func set_open(val):
	print(val, open)
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
		toast_cache.append(area)
		area.bump()

func _on_Area2D_area_exit( area ):
	if area in toast_cache and can_move():
		toast_cache.remove(toast_cache.find(area))
		emit_signal('miss', area.type)

func _on_input_event( viewport, event, shape_idx ):
	if event.type in [InputEvent.MOUSE_BUTTON, InputEvent.SCREEN_TOUCH] and can_move():
		touching = event.pressed
		set_open(event.pressed)
