tool
extends Control

onready var title_label = $ScrollContainer/VBoxContainer/Content/HBoxContainer/Title
onready var type_option = $ScrollContainer/VBoxContainer/Content/HBoxContainer2/Type
onready var dict_label = $ScrollContainer/VBoxContainer/Content/HBoxContainer3/Dict
onready var tag_label = $ScrollContainer/VBoxContainer/Content/HBoxContainer4/Tag
onready var desc_label = $ScrollContainer/VBoxContainer/Content/HBoxContainer5/Desc
onready var version_spinbox = $ScrollContainer/VBoxContainer/Content/HBoxContainer6/VersionSpinBox
onready var screenshot_label = $ScrollContainer/VBoxContainer/Content/HBoxContainer7/Screenshot
onready var license_option = $ScrollContainer/VBoxContainer/Content/HBoxContainer8/License
onready var folder_label = $ScrollContainer/VBoxContainer/Content/HBoxContainer9/Folder
onready var folder_button = $ScrollContainer/VBoxContainer/Content/HBoxContainer9/SelectFolder
onready var content_CID_label = $ScrollContainer/VBoxContainer/ContentCID/HBoxContainer9/ContentCID
onready var content_folder_label = $ScrollContainer/VBoxContainer/ContentPCK/HBoxContainer9/ContentFolder
onready var PCK_CID_label = $ScrollContainer/VBoxContainer/ContentPCK/HBoxContainer11/PCKCID
onready var content_filedialog = $FileDialog

onready var upload_content_button = $ScrollContainer/VBoxContainer/Content/UploadContent
onready var download_content_button = $ScrollContainer/VBoxContainer/ContentCID/DownloadContent
onready var upload_content_pck_button = $ScrollContainer/VBoxContainer/ContentPCK/UploadContentPCK
onready var submit_info_button = $ScrollContainer/VBoxContainer/Platform/SubmitInfo


func set_enable_change_metadata(val):
	title_label.editable = val
	type_option.disabled = not val
	dict_label.editable = val
	tag_label.editable = val
	desc_label.editable = val
	version_spinbox.editable = val
	screenshot_label.editable = val
	license_option.disabled = not val
	folder_label.editable = val
	folder_button.disabled = not val
	
	
enum STAGE{
	WAITING=-1,
	UPLOAD_CONTENT=0,
	DOWNLOAD_CONTENT=1,
	UPLOAD_CONTENT_PCK=2,
	SUBMITNFO=3,
}

var stage setget set_stage,get_stage
func set_stage(val):
	stage = val
	enable_button(stage)
	set_enable_change_metadata(stage == STAGE.UPLOAD_CONTENT)


func enable_button(index):
	var button_array = [
		upload_content_button,download_content_button,
		upload_content_pck_button,submit_info_button
	]
	for i in range(len(button_array)):
		button_array[i].disabled = (index!=i)

func get_stage():
	return stage
	


func _on_SelectFolder_pressed():
	content_filedialog.popup()



func _on_ClearAll_pressed():
	init_all()

func init_all():
	title_label.text = ""
	type_option.clear()
	for base_name in UGC.data_manger.data_constant.CONTENT_TYPE:
		type_option.add_item(base_name)
	type_option.selected = 0
	dict_label.text = ""
	tag_label.text = ""
	desc_label.text = ""
	version_spinbox.value = 0
	screenshot_label.text = ""
	license_option.selected = 0
	folder_label.text = ""
	content_CID_label.text = ""
	content_folder_label.text = ""
	PCK_CID_label.text = ""
	set_stage(STAGE.UPLOAD_CONTENT)


func _on_Content_FileDialog_file_selected(path):
	folder_label.text = path


func _on_Content_FileDialog_dir_selected(dir):
	folder_label.text = dir


func _on_UploadContent_pressed():
	var args = {
	"folder":folder_label.text,
	"metadata_dict":
		{
			"title":title_label.text,
			"type":type_option.text,
			"dict":dict_label.text,
			"tag":tag_label.text,
			"desc":desc_label.text,
			"version":"%d"%version_spinbox.value,
			"screenshot":screenshot_label.text,
			"author":UGC.platform_account.account,
			"license":license_option.text,
		}
	}
	UGC.data_manger.content_upload.ugc_upload(args)
	set_stage(STAGE.WAITING)


func upload_file_result(cid,type,content_cid):
	match type:
		UGC.data_manger.data_constant.DATATYPE.CONTENT:
			content_CID_label.text = cid
			set_stage(STAGE.DOWNLOAD_CONTENT)
		UGC.data_manger.data_constant.DATATYPE.CONTENT_PCK:
			PCK_CID_label.text = cid
			set_stage(STAGE.SUBMITNFO)
			
func download_file_result(cid,type,folder):
	match type:
		UGC.data_manger.data_constant.DATATYPE.CONTENT:
			content_folder_label.text = ProjectSettings.localize_path(folder)
			set_stage(STAGE.UPLOAD_CONTENT_PCK)
		UGC.data_manger.data_constant.DATATYPE.CONTENT_PCK:
			pass


func _on_DownloadContent_pressed():
	UGC.data_manger.content_download.ugc_download(content_CID_label.text)
	set_stage(STAGE.WAITING)


func _on_UploadContentPCK_pressed():
	UGC.data_manger.content_pck_upload.ugc_upload({"folder":content_folder_label.text})
	set_stage(STAGE.WAITING)



func _ready():
	yield(get_tree().create_timer(1),"timeout")
	init_all()
	content_init()


func content_init():
	UGC.data_protocol.connect("upload_file_result",self,"upload_file_result")
	UGC.data_protocol.connect("download_file_result",self,"download_file_result")
	

func _on_SubmitInfo_pressed():
	var metadata = {
			"title":title_label.text,
			"type":type_option.text,
			"dict":dict_label.text,
			"tag":tag_label.text,
			"desc":desc_label.text,
			"version":"%d"%version_spinbox.value,
			"screenshot":screenshot_label.text,
			"author":UGC.platform_account.account,
			"license":license_option.text,
		}
	UGC.platform_account.add_content_info(content_CID_label.text,PCK_CID_label.text,metadata)
	# 上传成功后先直接置空
	init_all()
