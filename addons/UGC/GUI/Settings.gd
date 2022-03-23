tool
extends Control

onready var platform_login_container = $ScrollContainer/VBoxContainer/Platform/PlatformLogin
onready var platform_status_container = $ScrollContainer/VBoxContainer/Platform/PlatformStatus
onready var platform_account_label = $ScrollContainer/VBoxContainer/Platform/PlatformLogin/PlatformAccount
onready var platform_password_label = $ScrollContainer/VBoxContainer/Platform/PlatformLogin/PlatformPassword
onready var platform_username_label = $ScrollContainer/VBoxContainer/Platform/PlatformStatus/PlatformUsername

signal platform_login
signal platform_logout
enum PLATFORM_STATUS {
	INIT,
	CONNECTING,
}
var platform_status setget set_platform_status,get_platform_status
func set_platform_status(val):
	platform_status = val
	var init_visible = true
	match platform_status:
		PLATFORM_STATUS.INIT:
			init_visible = true
		PLATFORM_STATUS.CONNECTING:
			init_visible = false
	platform_login_container.visible = init_visible
	platform_status_container.visible = not init_visible

func get_platform_status():
	return platform_status

func platform_init():
	set_platform_status(PLATFORM_STATUS.INIT)

func platform_logouted():
	set_platform_status(PLATFORM_STATUS.INIT)

func platform_logined():
	set_platform_status(PLATFORM_STATUS.CONNECTING)

func _on_Platform_Login_pressed():
	emit_signal("platform_login",platform_account_label.text,platform_password_label.text)

var platform_username setget set_platform_username,get_platform_username
func set_platform_username(val):
	platform_username = val
	platform_username_label.text = platform_username
	

func get_platform_username():
	return platform_username

func _on_Platform_Logout_pressed():
	emit_signal("platform_logout")


onready var wallet_login_container = $ScrollContainer/VBoxContainer/Wallet/WalletLogin
onready var wallet_status_container = $ScrollContainer/VBoxContainer/Wallet/WalletStatus

onready var wallet_QR_texture = $ScrollContainer/VBoxContainer/Wallet/WalletLogin/QR
onready var wallet_id_label = $ScrollContainer/VBoxContainer/Wallet/WalletStatus/WalletID

signal wallet_logout

enum WALLET_STATUS {
	INIT,
	CONNECTING,
}
var wallet_status setget set_wallet_status,get_wallet_status


func set_wallet_status(val):
	wallet_status = val
	var init_visible = true
	match wallet_status:
		WALLET_STATUS.INIT:
			init_visible = true
		WALLET_STATUS.CONNECTING:
			init_visible = false
	wallet_login_container.visible = init_visible
	wallet_status_container.visible = not init_visible

func get_wallet_status():
	return wallet_status

func wallet_init():
	set_wallet_status(WALLET_STATUS.INIT)
	UGC.wallet_account.connect("wallet_status_update",self,"wallet_status_update")
	UGC.wallet_account.connect("address_update",self,"wallet_status_update") # todo: address_update!=wallet_status_update
	
	UGC.wallet_account.connect("address_update",self,"address_update")
	UGC.wallet_account.connect("qr_url_update",self,"update_qr_url")

func wallet_logouted():
	set_wallet_status(WALLET_STATUS.INIT)

func wallet_logined():
	set_wallet_status(WALLET_STATUS.CONNECTING)

func wallet_status_update():
	if UGC.wallet_account.address!="":
		wallet_logined()
	else:
		wallet_logouted()

func update_qr_url():
	set_wallet_qr_url(UGC.wallet_account.qr_url)

var wallet_qr_url setget set_wallet_qr_url,get_wallet_qr_url
func set_wallet_qr_url(val):
	wallet_qr_url = val
	wallet_QR_texture.texture.content = wallet_qr_url

func get_wallet_qr_url():
	return wallet_qr_url


func _on_Wallet_UpdateQR_pressed():
	UGC.wallet_account.get_wallet_url()

func _on_Wallet_Logout_pressed():
#	UGC.wallet_account.get_wallet_url()
	print("todo:wallet_logout")
	
func address_update():
	set_wallet_id(UGC.wallet_account.address)

var wallet_id setget set_wallet_id,get_wallet_id
func set_wallet_id(val):
	wallet_id = val
	wallet_id_label.text = wallet_id

func get_wallet_id():
	return wallet_id


onready var nodejs_login_container = $ScrollContainer/VBoxContainer/NodeJS/NodeJSInit
onready var nodejs_status_container = $ScrollContainer/VBoxContainer/NodeJS/NodeJSStatus
onready var nodejs_file_dialog = $FileDialog
onready var nodejs_folder_label = $ScrollContainer/VBoxContainer/NodeJS/NodeJSInit/HBoxContainer/NodeJSFolder
enum NODEJS_STATUS {
	INIT,
	CONNECTING,
}
var nodejs_status setget set_nodejs_status,get_nodejs_status

func set_nodejs_status(val):
	nodejs_status = val
	var init_visible = true
	match nodejs_status:
		NODEJS_STATUS.INIT:
			init_visible = true
		NODEJS_STATUS.CONNECTING:
			init_visible = false
	nodejs_login_container.visible = init_visible
	nodejs_status_container.visible = not init_visible

func get_nodejs_status():
	return nodejs_status


func nodejs_init():
	set_nodejs_status(NODEJS_STATUS.INIT)
	UGC.nodejs_client.connect("nodejs_connected",self,"nodejs_logined")
	UGC.nodejs_client.connect("nodejs_logouted",self,"nodejs_logouted")

func nodejs_logouted():
	set_nodejs_status(NODEJS_STATUS.INIT)

func nodejs_logined():
	set_nodejs_status(NODEJS_STATUS.CONNECTING)


func _on_NodeJSFolderButton_pressed():
	nodejs_file_dialog.popup()


func _on_Nodejs_FileDialog_dir_selected(dir):
	nodejs_folder_label.text = dir


func _on_FileDialog_file_selected(path):
	nodejs_folder_label.text = path

func _on_nodejs_Connect_pressed():
	UGC.nodejs_client.nodejs_path = nodejs_folder_label.text
	UGC.nodejs_client.init_nodejs_server()
	UGC.nodejs_client.login_node_server()

func _on_nodejs_Logout_pressed():
	UGC.nodejs_client.close_node_server()

onready var token_label = $ScrollContainer/VBoxContainer/Token/Token

var token setget set_token,get_token
func set_token(val):
	token = val
	token_label.text = token

func get_token():
	return token

func _on_Token_text_changed(new_text):
	pass

func _ready():
	yield(get_tree().create_timer(1),"timeout")
	platform_init()
	wallet_init()
	nodejs_init()





