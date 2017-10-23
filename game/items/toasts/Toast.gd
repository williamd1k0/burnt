extends Area2D


signal toasted(type)

export(int, \
	'common', 'jam', 'burnt' \
) var type = 0

func toasted():
	emit_signal('toasted', type)
	queue_free()
	return type

func bump():
	get_node("AnimationPlayer").play("roll")

func _on_Toast_area_enter( area ):
	if area.is_in_group('shoot') and get_global_pos().y > 0:
		bump()
		toasted()
