tool
extends HBoxContainer
var game_search_type = preload("res://addons/UGC/GUI/GameLibrary/GameSearchType.gd").new()

onready var add_img = $"Control/AddImg"
onready var sub_img = $"Control/SubImg"
onready var name_label = $"Name"

var select_flag setget set_select_flag,get_select_flag
var type_name setget set_type_name

signal close_type

func _ready():
	pass
	

func set_select_flag(val):
	match val:
		game_search_type.SEARCH_MODE.NONE:
			add_img.visible = false
			sub_img.visible = false
		game_search_type.SEARCH_MODE.ADD:
			add_img.visible = true
			sub_img.visible = false
		game_search_type.SEARCH_MODE.SUB:
			add_img.visible = false
			sub_img.visible = true
		game_search_type.SEARCH_MODE.SEARCH:
			add_img.visible = false
			sub_img.visible = false

func get_select_flag():
	if (not add_img.visible) and (not sub_img.visible):
		return game_search_type.SEARCH_MODE.SEARCH
	if add_img.visible:
		return game_search_type.SEARCH_MODE.ADD
	if sub_img.visible:
		return game_search_type.SEARCH_MODE.SUB
		
func set_type_name(val):
	type_name = val
	name_label.text = type_name


func _on_CloseButton_pressed():
	emit_signal("close_type")

