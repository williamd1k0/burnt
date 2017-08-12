extends Sprite


signal toasted

export(int, 'common', 'jam', 'burnt') var type = 0
export(float) var speed = 20

func toasted():
	emit_signal('toasted')
	queue_free()
	return type
