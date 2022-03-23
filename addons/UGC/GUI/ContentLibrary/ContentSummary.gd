tool
extends MarginContainer
## 编辑器插件显示有点问题，和运行时不一致，所以指定了minsize

onready var icon_texture = $"HBoxContainer/MarginContainer/AspectRatioContainer/Icon"
onready var name_label = $"HBoxContainer/VBoxContainer/HBoxContainer/Name"
onready var type_label = $"HBoxContainer/VBoxContainer/HBoxContainer2/Type"
onready var license_label = $"HBoxContainer/VBoxContainer/HBoxContainer3/License"
onready var version_label = $"HBoxContainer/VBoxContainer/HBoxContainer5/Version"
onready var author_label = $"HBoxContainer/VBoxContainer/HBoxContainer4/Author"
onready var score_progress = $"HBoxContainer/MarginContainer2/VBoxContainer/AspectRatioContainer/TextureProgress"
onready var score_label = $"HBoxContainer/MarginContainer2/VBoxContainer/AspectRatioContainer/TextureProgress/CenterContainer/Label"
onready var price_progress = $"HBoxContainer/MarginContainer2/VBoxContainer/AspectRatioContainer2/TextureProgress"
onready var price_label = $"HBoxContainer/MarginContainer2/VBoxContainer/AspectRatioContainer2/TextureProgress/CenterContainer/Label"


var content_id
var content_icon setget set_content_icon
var content_name setget set_content_name
var content_type setget set_content_type
var content_license setget set_content_license
var content_author setget set_content_author
var content_score setget set_content_score
var content_price setget set_content_price
var content_desc setget set_content_desc
var content_version setget set_content_version
var content_cid


func set_content_icon(val):
	content_icon = val
	print(content_icon)
	UGC.load_utils.load_tex(icon_texture,val)

func set_content_name(val):
	content_name = val
	name_label.text = val

func set_content_type(val):
	content_type = val
	type_label.text = val

func set_content_license(val):
	content_license = val
	license_label.text = val

func set_content_author(val):
	content_author = val
	author_label.text = val


func set_content_score(val):
	content_score = val
	score_label.text = "%d"%val
	score_progress.value = val
	
func set_content_price(val):
	content_price = val
	price_label.text = "%d"%val
	price_progress.value = val

func set_content_desc(val):
	content_desc = val
	icon_texture.hint_tooltip = val

func set_content_version(val):
	content_version = val
	version_label.text = val

func _on_DownloadButton_pressed():
	UGC.data_manger.content_download.ugc_download(content_cid)


func update_metadata(metadata):
	content_id = metadata.id
	set_content_score(metadata.score)
	set_content_price(metadata.price)
	set_content_name(metadata.title)
	set_content_type(metadata.type)
	set_content_desc(metadata.desc)
	set_content_version(metadata.version)
	set_content_icon(metadata.screenshot)
	set_content_author(metadata.author)
	set_content_license(metadata.license)

