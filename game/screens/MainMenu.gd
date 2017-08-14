extends Node

var stack = []

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("pause") and stack.size() > 1:
		rollback_stack()

func rollback_stack():
	stack.pop_front()
	get_node("MenuStack").play(stack[0])

func _on_Play_pressed():
	get_node("MenuStack").play("diff")

func _on_Quit_pressed():
	get_tree().quit()

func _on_MenuStack_animation_started( name ):
	if stack.empty() or stack[0] != name:
		stack.push_front(name)
