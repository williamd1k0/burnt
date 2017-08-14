extends Node

const MAIN_MENU = preload('./MainMenu.tscn')
const LEVEL = preload('./Level.tscn')

func _ready():
	add_main_menu()

func clear():
	if get_child_count() > 0:
		for i in get_children():
			i.queue_free()

func add_main_menu():
	clear()
	var m_menu = MAIN_MENU.instance()
	m_menu.connect('play', self, 'add_level')
	add_child(m_menu)

func add_level(diff):
	clear()
	ToastSpawner.difficulty = diff
	var level = LEVEL.instance()
	add_child(level)
