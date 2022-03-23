tool
extends Control

onready var game_type_container = $"NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer"
onready var bg_panel = $"NinePatchRect"
export(PackedScene) var game_type_tscn

signal change_game_type_dict

var game_type_dict setget set_game_type_dict,get_game_type_dict

var game_search_type = preload("res://addons/UGC/GUI/GameLibrary/GameSearchType.gd").new()


func _ready():
	yield(get_tree().create_timer(1),"timeout")
	set_game_type_dict({})
#	UGC.utils.change_y_to_windoiw(bg_panel)
	

func set_game_type_dict(val):
	UGC.utils.remove_all_child(game_type_container)
	for type_name in val:
		if val[type_name] == game_search_type.SEARCH_MODE.SEARCH:
			continue
		var node = game_type_tscn.instance()
		game_type_container.add_child(node)
		node.type_name = type_name
		node.select_flag = val[type_name]
		node.connect("change_select_flag",self,"button_change_select_flag")
	for base_name in UGC.data_manger.data_constant.GAME_TYPE:
		if base_name in val:
			continue
		var node = game_type_tscn.instance()
		game_type_container.add_child(node)
		node.type_name = base_name
		node.select_flag = game_search_type.SEARCH_MODE.NONE
		node.connect("change_select_flag",self,"button_change_select_flag")
	pass
	
func get_game_type_dict():
	var type_dict = {}
	for node in game_type_container.get_children():
		type_dict[node.type_name] = node.select_flag
	return type_dict

func button_change_select_flag():
	emit_signal("change_game_type_dict")

func show_info():
	visible = true
	rect_scale = Vector2(0,0)
	$AnimationPlayer.play("show_info")
	
func hide_info():
	$AnimationPlayer.play("hide_info")
