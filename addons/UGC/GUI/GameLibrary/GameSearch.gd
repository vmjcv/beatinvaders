tool
extends VBoxContainer

onready var game_type_message_container = $"MarginContainer2/MarginContainer/SearchGameType"
onready var search_line = $"MarginContainer/HBoxContainer/NinePatchRect/MarginContainer/LineEdit"
onready var game_type_list = $"MarginContainer/HBoxContainer/InfoButton/GameTypeList"
var game_search_type = preload("res://addons/UGC/GUI/GameLibrary/GameSearchType.gd").new()

export(PackedScene) var game_type_label_tscn

var game_type_dict setget set_game_type_dict,get_game_type_dict

var search_type_node

func _ready():
	pass


func change_game_type_dict_from_info():
	set_game_type_dict(game_type_list.game_type_dict)
	
func set_game_type_dict(val):
	UGC.utils.remove_all_child(game_type_message_container)
	search_type_node = null
	update_search_label()
	for type_name in val:
		if val[type_name] == game_search_type.SEARCH_MODE.NONE:
			continue
		var node = game_type_label_tscn.instance()
		game_type_message_container.add_child(node)
		node.type_name = type_name
		node.select_flag = val[type_name]
		node.connect("close_type",self,"close_type",[node])
	game_type_list.game_type_dict = get_game_type_dict()
	pass

func get_game_type_dict():
	var type_dict ={}
	for node in game_type_message_container.get_children():
		type_dict[node.type_name] = node.select_flag
	return type_dict

func update_search_label():
	if (not search_type_node) or (not is_instance_valid(search_type_node)):
		var node = game_type_label_tscn.instance()
		game_type_message_container.add_child(node)
		search_type_node = node
		search_type_node.select_flag = game_search_type.SEARCH_MODE.SEARCH
		search_type_node.connect("close_type",self,"close_type",[node])
	search_type_node.type_name = search_line.text


func _on_LineEdit_text_changed(new_text):
	update_search_label()

func close_type(node):
	if node.select_flag == game_search_type.SEARCH_MODE.SEARCH:
		search_line.text = ""
		update_search_label()
		return
	node.queue_free()
	game_type_list.game_type_dict = get_game_type_dict()


func _on_InfoButton_toggled(button_pressed):
	if button_pressed:
		game_type_list.show_info()
	else:
		game_type_list.hide_info()

func _on_search(new_text=null):
	print("search")
	search_game_list(0)


func _on_GameButtonList_get_new_list(begin_index):
	search_game_list(begin_index)

func search_game_list(begin_index=0):
	var game_name
	var include_array = []
	var exclude_array = []
	var flag_dict = get_game_type_dict()
	for key in flag_dict:
		var data = flag_dict[key]
		match data:
			game_search_type.SEARCH_MODE.SEARCH:
				game_name = data
			game_search_type.SEARCH_MODE.ADD:
				include_array.append(data)
			game_search_type.SEARCH_MODE.SUB:
				exclude_array.append(data)
	UGC.platform_account.search_game(game_name,begin_index,include_array,exclude_array)
