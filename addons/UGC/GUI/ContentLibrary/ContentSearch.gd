tool
extends VBoxContainer

onready var content_type_message_container = $"MarginContainer2/MarginContainer/SearchContentType"
onready var search_line = $"MarginContainer/HBoxContainer/NinePatchRect/MarginContainer/LineEdit"
onready var content_type_list = $"CanvasLayer/Node2D/ContentTypeList"
var content_search_type = preload("res://addons/UGC/GUI/ContentLibrary/ContentSearchType.gd").new()

export(PackedScene) var content_type_label_tscn

var content_type_dict setget set_content_type_dict,get_content_type_dict

var search_type_node

func _ready():
	pass


func _on_ContentTypeList_change_content_type_dict():
	set_content_type_dict(content_type_list.content_type_dict)

	
func set_content_type_dict(val):
	UGC.utils.remove_all_child(content_type_message_container)
	search_type_node = null
	update_search_label()
	var begin = true
	for type_name in val:
		if val[type_name] == content_search_type.SEARCH_MODE.NONE:
			continue
		var node = content_type_label_tscn.instance()
		content_type_message_container.add_child(node)
		node.type_name = type_name
		node.select_flag = val[type_name]
		node.connect("close_type",self,"close_type",[node])
		if begin:
			content_type_message_container.columns = int(floor((content_type_message_container.rect_size.x -50) / node.rect_size.x))
			begin = false
	content_type_list.content_type_dict = get_content_type_dict()
	pass

func get_content_type_dict():
	var type_dict ={}
	for node in content_type_message_container.get_children():
		type_dict[node.type_name] = node.select_flag
	return type_dict

func update_search_label():
	if (not search_type_node) or (not is_instance_valid(search_type_node)):
		var node = content_type_label_tscn.instance()
		content_type_message_container.add_child(node)
		search_type_node = node
		search_type_node.select_flag = content_search_type.SEARCH_MODE.SEARCH
		search_type_node.connect("close_type",self,"close_type",[node])
	search_type_node.type_name = search_line.text


func _on_LineEdit_text_changed(new_text):
	update_search_label()

func close_type(node):
	if node.select_flag == content_search_type.SEARCH_MODE.SEARCH:
		search_line.text = ""
		update_search_label()
		return
	node.queue_free()
	content_type_list.content_type_dict = get_content_type_dict()


func _on_InfoButton_toggled(button_pressed):
	if button_pressed:
		content_type_list.show_info()
	else:
		content_type_list.hide_info()

func _on_search(new_text=null):
	search_content_list(0)


func search_content_list(begin_index=0):
	var content_name
	var include_array = []
	var exclude_array = []
	var flag_dict = get_content_type_dict()
	for key in flag_dict:
		var data = flag_dict[key]
		match data:
			content_search_type.SEARCH_MODE.SEARCH:
				content_name = data
			content_search_type.SEARCH_MODE.ADD:
				include_array.append(data)
			content_search_type.SEARCH_MODE.SUB:
				exclude_array.append(data)
	UGC.platform_account.search_content(content_name,begin_index,include_array,exclude_array)


func _on_ContentSummaryList_get_new_list(begin_index):
	search_content_list(begin_index)
