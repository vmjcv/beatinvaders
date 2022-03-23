tool
extends ScrollContainer


export(PackedScene) var game_summary_scene

onready var game_container = $"VBoxContainer"

var now_selected_button
signal get_new_list


func _ready():
	yield(get_tree().create_timer(1),"timeout")
	get_v_scrollbar().connect("value_changed",self,"v_scrollbar_change")
	UGC.platform_protocol.connect("search_update",self,"search_update")
	pass

func search_update(game_dict_list,begin_index):
	UGC.utils.remove_all_child_begin_index(game_container,begin_index)
	add_game_list(game_dict_list)
	pass

func add_game_list(game_dict_list):
	for game_dict in game_dict_list:
		add_game(game_dict)
	pass

func add_game(game_dict):
	var game_node = game_summary_scene.instance()
	game_container.add_child(game_node)
	game_node.game_icon = game_dict["icon"]
	game_node.game_name = game_dict["title"]
	game_node.game_each_depleted_power = game_dict["each_depleted_power"]
	game_node.game_total_entrance_fee = game_dict["total_entrance_fee"]
	game_node.game_exp_reward = game_dict["exp_reward"]
	game_node.game_score = game_dict["score"]
	game_node.game_author = game_dict["author"]
	game_node.game_id = game_dict["id"]
	game_node.connect("pressed",self,"select_game",[game_node])


func select_game(game_node):
	if game_node == now_selected_button:
		return
	if now_selected_button:
		now_selected_button.selected = false
	now_selected_button = game_node
	now_selected_button.selected = true
	UGC.platform_account.show_game_detail(now_selected_button.game_id)


func v_scrollbar_change(val):
	var scroll_len = get_v_scrollbar().max_value-get_v_scrollbar().rect_size.y
	if scroll_len>0 and val/scroll_len>=0.95:
		emit_signal("get_new_list",game_container.get_child_count())
