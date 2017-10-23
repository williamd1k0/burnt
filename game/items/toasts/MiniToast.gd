tool
extends Sprite

var speed = 64
export(String, \
	'none', 'common', 'jam', 'burnt' \
) var toast = 'none' setget _set_toast

func _ready():
	if not get_tree().is_editor_hint():
		set_process(true)

func shoot():
	speed = 100
	get_node("HurtBox").set_monitorable(true)
	get_node("HurtBox").set_enable_monitoring(true)

func _process(delta):
	translate(Vector2(0, -speed*delta))

func _set_toast(val):
	toast = val
	if not is_inside_tree():
		yield(self, 'enter_tree')
	get_node("AnimationPlayer").play(toast)

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
