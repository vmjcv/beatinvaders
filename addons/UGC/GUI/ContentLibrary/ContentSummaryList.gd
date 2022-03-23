tool
extends ScrollContainer


export(PackedScene) var content_summary_scene

onready var content_container = $"GridContainer"

var now_selected_button
signal get_new_list


func _ready():
	yield(get_tree().create_timer(1),"timeout")
	get_v_scrollbar().connect("value_changed",self,"v_scrollbar_change")
	UGC.platform_protocol.connect("search_content_update",self,"search_content_update")
	pass

func search_content_update(content_dict_list,begin_index):
	print(content_dict_list)
	UGC.utils.remove_all_child_begin_index(content_container,begin_index)
	add_content_list(content_dict_list)
	pass


func add_content_list(content_dict_list):
	var need_update_columns = true
	for content_dict in content_dict_list:
		add_content(content_dict,need_update_columns)
		need_update_columns = false
	pass

func add_content(content_dict,need_update_columns=false):
	var content_node = content_summary_scene.instance()
	content_container.add_child(content_node)
	content_node.content_cid = content_dict["cid"]
	content_node.update_metadata(content_dict["metadata"])
	if need_update_columns:
		content_container.columns = int(floor(content_container.rect_size.x / content_node.rect_size.x))

func v_scrollbar_change(val):
	if val/(get_v_scrollbar().max_value-get_v_scrollbar().rect_size.y)>=0.95:
		emit_signal("get_new_list",content_container.get_child_count())
