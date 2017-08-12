extends Area2D


signal toasted

export(int, 'common', 'jam', 'burnt') var type = 0

func toasted():
	# Rotating pixel art is a crime, don't try this at home
	get_node("AnimationPlayer").play("crime")
	return type

func _on_AnimationPlayer_finished():
	emit_signal('toasted')
	queue_free()
