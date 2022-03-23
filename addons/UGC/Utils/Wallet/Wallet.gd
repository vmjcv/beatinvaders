tool
extends Node
signal address_update
signal wallet_status_update
signal coin_amount_update
signal nft_update
signal qr_url_update

var address = "" setget set_address

func set_address(value):
	address = value
	emit_signal("address_update")

var wallet_status = 0 setget set_wallet_status
func set_wallet_status(value):
	wallet_status = value
	emit_signal("wallet_status_update")

var coin_amount = 0 setget set_wallet_status
func set_coin_amount(value):
	coin_amount = value
	emit_signal("coin_amount_update")

var id_list = 0 setget set_id_list
func set_id_list(value):
	id_list = value
	emit_signal("nft_update")

var slime_list = 0 setget set_slime_list
func set_slime_list(value):
	slime_list = value
	update_nft_dict()
	emit_signal("nft_update")

var qr_url = 0 setget set_qr_url
func set_qr_url(value):
	qr_url = value
	emit_signal("qr_url_update")

var nft_dict = {} setget ,get_nft_dict
func get_nft_dict():
	#TODO:test
	slime_list = range(10000,10010)
	update_nft_dict()
	return nft_dict
		
func update_nft_dict():
	nft_dict = {}
	for index in slime_list:
		nft_dict[index] = {
			"level":randi()%10,
			"path":"res://UGCContent/bafybeid6tmotn6jb2qergxfsp5mzw5n35b3nkaqfesllrhfjymzhc4jo2q/icon.png",
			"data":{
				"Defense":randi()%10,
				"Attack":randi()%10,
				"HP":randi()%10,
			},
			
		}

func get_wallet_url():
	UGC.wallet_protocol.get_wallet_url()

func get_coin_amount():
	UGC.wallet_protocol.get_coin_amount()

func get_all_nft():
	UGC.wallet_protocol.get_all_nft()

func buy_coin(value):
	UGC.wallet_protocol.buy_coin(value)

func buy_nft(level,dna):
	UGC.wallet_protocol.buy_nft(level,dna)

func transfer_coin(target_address,amount):
	UGC.wallet_protocol.transfer_coin(target_address,amount)
