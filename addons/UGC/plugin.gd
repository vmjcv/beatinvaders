tool
extends EditorPlugin

var dock

func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instance it.
	dock = load("res://addons/UGC/GUI/UGC.tscn").instance()
	add_control_to_bottom_panel(dock,"UGC")
	add_autoload_singleton("UGC", "res://addons/UGC/Utils/Main/UGC.tscn")

func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()
	remove_autoload_singleton("UGC")

