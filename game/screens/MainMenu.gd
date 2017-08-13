extends Node

func _ready():
	pass

func _on_Play_pressed():
	get_node("AnimationPlayer").play("diff")
	get_node("ui/Menus/Difficulty/Buttons/Easy").grab_focus()

func _on_Quit_pressed():
	get_tree().quit()
