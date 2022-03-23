tool
extends MarginContainer
## 编辑器插件显示有点问题，和运行时不一致，所以指定了minsize

onready var icon_texture = $Button/HBoxContainer/MarginContainer/AspectRatioContainer/Icon
onready var name_label = $Button/HBoxContainer/VBoxContainer/HBoxContainer/Name
onready var price_label = $Button/HBoxContainer/VBoxContainer/HBoxContainer2/Price
onready var exp_label = $Button/HBoxContainer/VBoxContainer/HBoxContainer3/EXP
onready var author_label = $Button/HBoxContainer/VBoxContainer/HBoxContainer4/Author
onready var score_progress = $Button/HBoxContainer/MarginContainer2/AspectRatioContainer/TextureProgress
onready var score_label = $Button/HBoxContainer/MarginContainer2/AspectRatioContainer/TextureProgress/CenterContainer/Label

var game_id
var game_icon setget set_game_icon
var game_name setget set_game_name
var game_each_depleted_power=0 setget set_game_each_depleted_power
var game_total_entrance_fee=0 setget set_game_total_entrance_fee
var game_exp_reward setget set_game_exp_reward
var game_author setget set_game_author
var game_score setget set_game_score

var selected setget set_selected

signal pressed

func set_game_icon(val):
	game_icon = val
	UGC.load_utils.load_tex(icon_texture,val)

func set_game_name(val):
	game_name = val
	name_label.text = game_name

func set_game_each_depleted_power(val):
	game_each_depleted_power = val
	update_price()
	
func set_game_total_entrance_fee(val):
	game_total_entrance_fee = val
	update_price()

func update_price():
	if game_each_depleted_power>0:
		price_label.text = "Power:%d"%game_each_depleted_power
	elif game_total_entrance_fee>0:
		price_label.text = "Coin:%d"%game_total_entrance_fee
	else:
		price_label.text = "Free"

func set_game_exp_reward(val):
	game_exp_reward = val
	exp_label.text = "EXP:%d-%d"%game_exp_reward

func set_game_author(val):
	game_author = val
	author_label.text = "%s"%game_author


func set_game_score(val):
	game_score = val
	score_label.text = "%d"%game_score
	score_progress.value = game_score


func _on_Button_pressed():
	emit_signal("pressed")
	
func set_selected(val):
	selected = val
	# 选中和未选中的表现形态差异

