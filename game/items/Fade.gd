extends CanvasLayer

signal fadein
signal fadeout

onready var anime = get_node("AnimationPlayer")

func fadein():
	anime.play("fadein")
	yield(anime, 'finished')
	emit_signal("fadein")
	
func fadeout():
	anime.play("fadeout")
	yield(anime, 'finished')
	emit_signal("fadeout")

