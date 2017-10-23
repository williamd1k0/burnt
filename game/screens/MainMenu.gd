extends Node2D


var stack = []

func _ready():
	for button in get_node("ui/Menus/Difficulty/Buttons").get_children():
		if 'ds-mode' in OS.get_cmdline_args():
			button.set_hidden(button.get_name() != 'Hard')
		button.connect('pressed', self, '_on_Difficulty_pressed', [button.get_name()])
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel") and stack.size() > 1:
		rollback_stack()

func rollback_stack():
	stack.pop_front()
	get_node("MenuStack").play(stack[0])

func _on_Difficulty_pressed(diff):
	get_node("ScreenControl").next_scene({
		'diff': diff.to_lower(),
		'ds-mode': 'ds-mode' in OS.get_cmdline_args()
	})

func _on_Play_pressed():
	get_node("MenuStack").play("diff")
	for child in get_node("ui/Menus/Difficulty/Buttons").get_children():
		if not child.is_hidden():
			child.grab_focus()
			break

func _on_Quit_pressed():
	get_tree().quit()

func _on_MenuStack_animation_started( name ):
	if stack.empty() or stack[0] != name:
		stack.push_front(name)
