extends Area2D


signal toasted

export(int, 'common', 'jam', 'burnt') var type = 0

func toasted():
	emit_signal('toasted')
	queue_free()
	return type
