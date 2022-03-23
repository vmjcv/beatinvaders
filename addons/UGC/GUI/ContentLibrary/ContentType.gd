tool
extends Control
var content_search_type = preload("res://addons/UGC/GUI/ContentLibrary/ContentSearchType.gd").new()

onready var add_check_box = $"AddCheckBox"
onready var sub_check_box = $"SubCheckBox"
onready var name_label = $"NameLabel"


var select_flag setget set_select_flag,get_select_flag
var type_name setget set_type_name

signal change_select_flag


func _on_AddCheckBox_toggled(button_pressed):
	if button_pressed:
		sub_check_box.pressed = false
	emit_signal("change_select_flag")


func _on_SubCheckBox_toggled(button_pressed):
	if button_pressed:
		add_check_box.pressed = false
	emit_signal("change_select_flag")
	

func set_select_flag(val):
	match val:
		content_search_type.SEARCH_MODE.NONE:
			add_check_box.pressed = false
			sub_check_box.pressed = false
		content_search_type.SEARCH_MODE.ADD:
			add_check_box.pressed = true
			sub_check_box.pressed = false
		content_search_type.SEARCH_MODE.SUB:
			add_check_box.pressed = false
			sub_check_box.pressed = true

func get_select_flag():
	if (not add_check_box.pressed) and (not sub_check_box.pressed):
		return content_search_type.SEARCH_MODE.NONE
	if add_check_box.pressed:
		return content_search_type.SEARCH_MODE.ADD
	if sub_check_box.pressed:
		return content_search_type.SEARCH_MODE.SUB
		
func set_type_name(val):
	type_name = val
	name_label.text = type_name
