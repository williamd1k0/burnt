extends Node

enum {
	DEFAULT,
	TORROU=1<<0,
	DARK_SOULS=1<<1
}

var mode = 0

func _ready():
	if '--torrou' in OS.get_cmdline_args():
		mode |= TORROU
	if '--ds-mode' in OS.get_cmdline_args():
		mode |= DARK_SOULS

func is_dark_souls():
	return mode & DARK_SOULS

func is_torrou():
	return mode & TORROU
