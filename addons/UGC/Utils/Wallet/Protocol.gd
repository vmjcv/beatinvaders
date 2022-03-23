tool
extends Node

func _ready():
	yield(get_tree().root.get_child(get_tree().root.get_child_count()-1), "ready")
	var nodejs_client = UGC.nodejs_client
	var nodejs_constant = UGC.nodejs_client.nodejs_constant
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_LOGIN_WALLET,[self,"login_wallet_result"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_GET_COIN_AMOUNT,[self,"get_coin_result"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_GET_ALL_NFT,[self,"get_all_NFT_result"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_BUY_COIN,[self,"buy_coin_result"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_BUY_NFT,[self,"buy_NFT_result"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_TRANSFER_COIN,[self,"transfer_coin_result"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_UPDATE_WALLET_QR,[self,"update_wallet_QR"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_UPDATE_COIN,[self,"update_coin"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_UPDATE_NFT,[self,"update_NFT"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_UPDATE_ACCOUNT,[self,"update_account"])


func login_wallet_result(data):
	var account = data[0]
	UGC.wallet_account.address = account

func get_coin_result(data):
	var coin_amount = data[0]
	UGC.wallet_account.coin_amount = coin_amount

func get_all_NFT_result(data):
	var id_list = data[0]
	var slime_list = data[1]
	UGC.wallet_account.id_list = id_list
	UGC.wallet_account.slime_list = slime_list

func buy_coin_result(data):
	var ret = data[0]

func buy_NFT_result(data):
	var ret = data[0]

func transfer_coin_result(data):
	var ret = data[0]

func update_wallet_QR(data):
	var url = data[0]
	UGC.wallet_account.qr_url = url

func update_coin(data):
	var coin_amount = data[0]
	UGC.wallet_account.coin_amount = coin_amount

func update_NFT(data):
	var id_list = data[0]
	var slime_list = data[1]
	UGC.wallet_account.id_list = id_list
	UGC.wallet_account.slime_list = slime_list

func update_account(data):
	var account = data[0]
	UGC.wallet_account.address = account
	
	
func get_wallet_url():
	var data = []
	UGC.nodejs_client.call_server(UGC.nodejs_client.nodejs_constant.PROTOCOL.C_S_LOGIN_WALLET,data)

func get_coin_amount():
	var data = []
	UGC.nodejs_client.call_server(UGC.nodejs_client.nodejs_constant.PROTOCOL.C_S_GET_COIN_AMOUNT,data)

func get_all_nft():
	var data = []
	UGC.nodejs_client.call_server(UGC.nodejs_client.nodejs_constant.PROTOCOL.C_S_GET_ALL_NFT,data)

func buy_coin(value):
	var data = []
	data.append(value)
	UGC.nodejs_client.call_server(UGC.nodejs_client.nodejs_constant.PROTOCOL.C_S_BUY_COIN,data)

func buy_nft(level,dna):
	var data = []
	data.append(level)
	data.append(dna)
	UGC.nodejs_client.call_server(UGC.nodejs_client.nodejs_constant.PROTOCOL.C_S_BUY_NFT,data)

func transfer_coin(target_address,amount):
	var data = []
	data.append(target_address)
	data.append(amount)
	UGC.nodejs_client.call_server(UGC.nodejs_client.nodejs_constant.PROTOCOL.C_S_TRANSFER_COIN,data)
	
