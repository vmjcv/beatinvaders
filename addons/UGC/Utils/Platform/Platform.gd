tool
extends Node

var account = "" setget set_account,get_account
func set_account(value):
	account = value

func get_account():
	if account=="" or (not account):
		return "SlimeMetaWorld"
	return account 

func search_game(game_name,begin_index=0,include_array=[],exclude_array=[]):
	UGC.platform_protocol.search_game(game_name,begin_index,include_array,exclude_array)
	
func show_game_detail(game_id):
	UGC.platform_protocol.show_game_detail(game_id)
	

func add_content_info(cid,pck_cid,meta_data):
	UGC.platform_protocol.add_content_info(cid,pck_cid,meta_data)


func add_game_info(pck_cid,meta_data,game_use):
	UGC.platform_protocol.add_game_info(pck_cid,meta_data,game_use)

func search_content(content_name,begin_index=0,include_array=[],exclude_array=[]):
	UGC.platform_protocol.search_content(content_name,begin_index,include_array,exclude_array)
