extends PathFollow2D


func spawn_toast(toast):
	add_child(toast)
	toast.connect('toasted', self, 'free_toast', [toast])
	get_node("Tween").interpolate_method(
		self,
		'set_unit_offset',
		0.0, 1.0, 1.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN,
		1.0
	)
	get_node("Tween").start()

func free_toast(type, toast):
	toast.queue_free()

func _on_tween_complete( object, key ):
	queue_free()
