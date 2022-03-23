tool
extends Control

onready var PCK_CID_label = $ScrollContainer/VBoxContainer/Game/HBoxContainer11/PCKCID
onready var title_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer/Title
onready var type_option = $ScrollContainer/VBoxContainer/Platform/HBoxContainer2/Type
onready var icon_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer3/Icon
onready var icon_button = $ScrollContainer/VBoxContainer/Platform/HBoxContainer3/SelectFolder
onready var bg_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer4/BG
onready var bg_button = $ScrollContainer/VBoxContainer/Platform/HBoxContainer4/SelectFolder2
onready var desc_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer5/Desc
onready var everyone_power_spinbox = $ScrollContainer/VBoxContainer/Platform/HBoxContainer6/VBoxContainer/HBoxContainer/EveryonePower
onready var total_entrance_fee_spinbox = $ScrollContainer/VBoxContainer/Platform/HBoxContainer6/VBoxContainer/HBoxContainer2/TotalEntranceFee
onready var everyone_power_checkbox = $ScrollContainer/VBoxContainer/Platform/HBoxContainer6/VBoxContainer/HBoxContainer/CheckBox
onready var total_entrance_fee_checkbox = $ScrollContainer/VBoxContainer/Platform/HBoxContainer6/VBoxContainer/HBoxContainer2/CheckBox
onready var free_checkbox = $ScrollContainer/VBoxContainer/Platform/HBoxContainer6/VBoxContainer/HBoxContainer3/CheckBox

onready var icon_filedialog = $IconFileDialog
onready var bg_filedialog = $BGFileDialog

onready var upload_game_pck_button = $ScrollContainer/VBoxContainer/Game/UploadGamePCK
onready var submit_info_button = $ScrollContainer/VBoxContainer/Platform/SubmitInfo


onready var player1_check_box = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer/CheckBox
onready var player1_name_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer/PlayerName
onready var player1_init_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer/InitDesc
onready var player1_use_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer/UseDesc

onready var player2_check_box = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer2/CheckBox
onready var player2_name_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer2/PlayerName
onready var player2_init_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer2/InitDesc
onready var player2_use_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer2/UseDesc

onready var player3_check_box = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer3/CheckBox
onready var player3_name_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer3/PlayerName
onready var player3_init_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer3/InitDesc
onready var player3_use_label = $ScrollContainer/VBoxContainer/Platform/HBoxContainer7/VBoxContainer/HBoxContainer3/UseDesc


var price_buttongroup = ButtonGroup.new()
var player_array = []

func set_enable_change_metadata(val):
	title_label.editable = val
	type_option.disabled = not val
	icon_label.editable = val
	icon_button.disabled = not val
	bg_label.editable = val
	bg_button.disabled = not val
	desc_label.editable = val
	everyone_power_spinbox.editable = val
	total_entrance_fee_spinbox.editable = val
	everyone_power_checkbox.disabled = not val
	total_entrance_fee_checkbox.disabled = not val
	free_checkbox.disabled = not val
	player1_check_box.disabled = not val
	player2_check_box.disabled = not val
	player3_check_box.disabled = not val
	
	
	
enum STAGE{
	WAITING=-1,
	UPLOAD_GAME_PCK=0,
	SUBMITNFO=1,
}

var stage setget set_stage,get_stage
func set_stage(val):
	stage = val
	enable_button(stage)
	set_enable_change_metadata(stage == STAGE.SUBMITNFO)

func get_stage():
	return stage

func enable_button(index):
	var button_array = [
		upload_game_pck_button,
		submit_info_button
	]
	for i in range(len(button_array)):
		button_array[i].disabled = (index!=i)



func _ready():
	yield(get_tree().create_timer(1),"timeout")
	game_init()
	init_all()
	
	
func _on_ClearAll_pressed():
	init_all()

func init_all():
	PCK_CID_label.text = ""
	title_label.text = ""
	type_option.clear()
	for game_type in UGC.data_manger.data_constant.GAME_TYPE:
		type_option.add_item(game_type)
	type_option.selected = 0
	icon_label.text = ""
	bg_label.text = ""
	desc_label.text = ""
	everyone_power_spinbox.value = 0
	total_entrance_fee_spinbox.value = 0

	free_checkbox.pressed = true
	set_stage(STAGE.UPLOAD_GAME_PCK)
	for data in player_array:
		data["check"].pressed = false


func game_init():
	UGC.data_protocol.connect("upload_file_result",self,"upload_file_result")
	UGC.data_protocol.connect("download_file_result",self,"download_file_result")
	everyone_power_checkbox.group = price_buttongroup
	total_entrance_fee_checkbox.group = price_buttongroup
	free_checkbox.group = price_buttongroup
	price_buttongroup.connect("pressed",self,"price_button_pressed")
	player_array = [
		{"check":player1_check_box,"name":player1_name_label,"init":player1_init_label,"use":player1_use_label},
		{"check":player2_check_box,"name":player2_name_label,"init":player2_init_label,"use":player2_use_label},
		{"check":player3_check_box,"name":player3_name_label,"init":player3_init_label,"use":player3_use_label},
	]
	
func price_button_pressed(button):
	everyone_power_spinbox.editable = (button == everyone_power_checkbox)
	total_entrance_fee_spinbox.editable = (button == total_entrance_fee_checkbox)

func upload_file_result(cid,type,content_cid):
	match type:
		UGC.data_manger.data_constant.DATATYPE.GAME_PCK:
			PCK_CID_label.text = cid
			set_stage(STAGE.SUBMITNFO)
			
func download_file_result(cid,type,folder):
	match type:
		UGC.data_manger.data_constant.DATATYPE.GAME_PCK:
			pass


func _on_UploadGamePCK_pressed():
	UGC.data_manger.game_pck_upload.ugc_upload()
	set_stage(STAGE.WAITING)


func _on_Icon_SelectFolder_pressed():
	icon_filedialog.popup()


func _on_BG_SelectFolder_pressed():
	bg_filedialog.popup()


func _on_IconFileDialog_file_selected(path):
	icon_label.text = path


func _on_BGFileDialog_file_selected(path):
	bg_label.text = path


func _on_SubmitInfo_pressed():
	var role_list = []
	for data in player_array:
		if data["check"].pressed:
			role_list.append({
				"init_player_desc":data["init"].text,
				"use_player_desc":data["use"].text,
				"name":data["name"].text,
			})
	
	var metadata = {
			"title":title_label.text,
			"type":type_option.text,
			"icon":icon_label.text,
			"bg":bg_label.text,
			"desc":desc_label.text,
			"each_depleted_power":everyone_power_spinbox.value if everyone_power_checkbox.pressed else 0,
			"total_entrance_fee":total_entrance_fee_spinbox.value if total_entrance_fee_checkbox.pressed else 0,
			"author":UGC.platform_account.account,
			"role":role_list,
		}
	
	UGC.platform_account.add_game_info(PCK_CID_label.text,metadata,UGC.data_manger.game_pck_upload.get_use_array())
	# 上传成功后先直接置空
	init_all()


func _on_Player_CheckBox_toggled(button_pressed, index):
	var data = player_array[index]
	data["name"].editable = button_pressed
	data["init"].readonly = not button_pressed
	data["use"].readonly = not button_pressed
