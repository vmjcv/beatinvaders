tool
extends Control

var game_id
var game_name setget set_game_name
var game_bg setget set_game_bg
var game_desc setget set_game_desc
var game_score setget set_game_score
var game_role_list setget set_game_role_list,get_game_role_list
var game_level setget set_game_level
var game_author setget set_game_author
var game_type setget set_game_type
var game_exp_reward setget set_game_exp_reward
var game_each_depleted_power setget set_game_each_depleted_power
var game_total_entrance_fee setget set_game_total_entrance_fee

onready var game_bg_image = $"BG"
onready var game_score_label = $"HBoxContainer/MarginContainer/TextureRect2/TextureProgress/CenterContainer/Label"
onready var game_score_progress = $"HBoxContainer/MarginContainer/TextureRect2/TextureProgress"
onready var game_desc_label = $"HBoxContainer/MarginContainer/MarginContainer/VBoxContainer/Desc"
onready var game_name_label = $"HBoxContainer/MarginContainer/MarginContainer/VBoxContainer/Title"
onready var game_type_label = $"HBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Type"
onready var game_author_label = $"HBoxContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Author"
onready var game_role_container = $"HBoxContainer/MarginContainer2/VBoxContainer2/MarginContainer/TabContainer"
onready var game_level_label = $"HBoxContainer/MarginContainer2/VBoxContainer2/Control/MarginContainer/VBoxContainer/GameLevelContainer/GameLevel"
onready var game_exp_reward_label = $"HBoxContainer/MarginContainer2/VBoxContainer2/Control/MarginContainer/VBoxContainer/EXPRewardContainer/EXPReward"
onready var game_exp_reward_container = $"HBoxContainer/MarginContainer2/VBoxContainer2/Control/MarginContainer/VBoxContainer/EXPRewardContainer"
onready var game_each_deplete_power_label = $"HBoxContainer/MarginContainer2/VBoxContainer2/Control/MarginContainer/VBoxContainer/EachDepletePowerContainer/EachDepletePower"
onready var game_each_deplete_power_container = $"HBoxContainer/MarginContainer2/VBoxContainer2/Control/MarginContainer/VBoxContainer/EachDepletePowerContainer"
onready var game_total_entrance_fee_label = $"HBoxContainer/MarginContainer2/VBoxContainer2/Control/MarginContainer/VBoxContainer/TotalEntranceFeeContainer/TotalEntranceFee"
onready var game_total_entrance_fee_container = $"HBoxContainer/MarginContainer2/VBoxContainer2/Control/MarginContainer/VBoxContainer/TotalEntranceFeeContainer"


export(PackedScene) var game_role_desc

func set_game_name(val):
	game_name = val
	game_name_label.text = game_name


func set_game_type(val):
	game_type = val
	game_type_label.text = game_type
	
func set_game_author(val):
	game_author = val
	game_author_label.text = game_author

func set_game_bg(val):
	game_bg = val
	UGC.load_utils.load_tex(game_bg_image,val)

func set_game_desc(val):
	game_desc = val
	game_desc_label.bbcode_text = game_desc

func set_game_score(val):
	game_score = val
	game_score_label.text = "%d"%game_score
	game_score_progress.value = game_score

func set_game_level(val):
	game_level = val
	game_level_label.text = "%d"%game_level

func set_game_exp_reward(val):
	game_exp_reward = val
	game_exp_reward_label.text = "%d-%d"%game_exp_reward
	game_exp_reward_container.visible = (game_exp_reward[1]>0)

func set_game_each_depleted_power(val):
	game_each_depleted_power = val
	game_each_deplete_power_label.text = "%d"%game_each_depleted_power
	game_each_deplete_power_container.visible = (game_each_depleted_power>0)


func set_game_total_entrance_fee(val):
	game_total_entrance_fee = val
	game_total_entrance_fee_label.text = "%d"%game_total_entrance_fee
	game_total_entrance_fee_container.visible = (game_total_entrance_fee>0)


func set_game_role_list(val):
	game_role_list = val
	UGC.utils.remove_all_child(game_role_container)
	for data in game_role_list:
		var node = game_role_desc.instance()
		game_role_container.add_child(node)
		node.init_desc = data.init_player_desc
		node.use_desc = data.use_player_desc
		node.name = data.name

func get_game_role_list():
	return game_role_list



func _ready():
	yield(get_tree().create_timer(1),"timeout")
	UGC.platform_protocol.connect("detail_update",self,"search_update")
	pass
	
func search_update(metadata):
	visible = true
	game_id = metadata.id
	set_game_name(metadata.title)
	set_game_bg(metadata.bg)
	set_game_desc(metadata.desc)
	set_game_score(metadata.score)
	set_game_level(metadata.level)
	set_game_exp_reward(metadata.exp_reward)
	set_game_each_depleted_power(metadata.each_depleted_power)
	set_game_total_entrance_fee(metadata.total_entrance_fee)
	set_game_author(metadata.author)
	set_game_type(metadata.type)
	set_game_role_list(metadata.role)
