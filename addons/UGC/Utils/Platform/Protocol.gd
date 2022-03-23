tool
extends Node

var cid_map = load("res://addons/UGC/Utils/Platform/CIDMap.gd").new()
signal search_update
signal detail_update
signal search_content_update

func _ready():
	yield(get_tree().root.get_child(get_tree().root.get_child_count()-1), "ready")

func add_content_info(cid,pck_cid,meta_data):
	cid_map.set_content_pck(cid,pck_cid)
	cid_map.set_metadata(cid,meta_data)
	meta_data["id"] = randi()%100000
	meta_data["score"] = randi()%100
	meta_data["price"] = randi()%100 if meta_data.license == "SBAU" else 0
	cid_map.set_type(cid,UGC.data_manger.data_constant.DATATYPE.CONTENT)


func get_content_info(cid):
	return {
		"cid":cid,
		"type":cid_map.get_type(cid),
		"pck":cid_map.get_content_pck(cid),
		"metadata":cid_map.get_metadata(cid),
	}

func add_game_info(pck_cid,meta_data,game_use):
	cid_map.set_game_use(pck_cid,game_use)
	meta_data["id"] = randi()%100000
	meta_data["score"] = randi()%100
	var min_exp_reward = randi()%5
	var add_exp_reward = randi()%3
	meta_data["exp_reward"] = [min_exp_reward,min_exp_reward+add_exp_reward]
	meta_data["level"] = randi()%10
	cid_map.set_metadata(pck_cid,meta_data)
	cid_map.set_type(pck_cid,UGC.data_manger.data_constant.DATATYPE.GAME_PCK)
	

func get_game_info(cid):
	return {
		"cid":cid,
		"type":cid_map.get_type(cid),
		"metadata":cid_map.get_metadata(cid),
		"use":cid_map.get_game_use(cid),
	}
	
func get_game_info_by_id(game_id):
	var all_game_cid = cid_map.get_all_game_cid()
	for cid in all_game_cid:
		if cid_map.get_metadata(cid)["id"] == game_id:
			return {
					"cid":cid,
					"type":cid_map.get_type(cid),
					"metadata":cid_map.get_metadata(cid),
					"use":cid_map.get_game_use(cid),
				}
	
	
func search_game(game_name,begin_index=0,include_array=[],exclude_array=[]):
	var all_game_cid = cid_map.get_all_game_cid()
	var game_array = []
	for cid in all_game_cid:
		var metadata = cid_map.get_metadata(cid)
#		var new_data = {
#			"title":metadata.title,
#			"icon":metadata.icon,
#			"each_depleted_power":metadata.each_depleted_power,
#			"total_entrance_fee":metadata.total_entrance_fee,
#			"author":metadata.author,
#			"id":metadata.id,
#			"score":metadata.score,
#			"exp_reward":metadata.exp_reward,
#		}
		game_array.append(metadata)
	emit_signal("search_update",game_array.slice(begin_index,begin_index+10),begin_index)
	return 
	
func search_content(content_name,begin_index=0,include_array=[],exclude_array=[]):
	var all_game_cid = cid_map.get_all_content_cid()
	var content_array = []
	for cid in all_game_cid:
		var metadata = cid_map.get_metadata(cid)
		
		
#		var new_data = {
#			"title":metadata.title,
#			"icon":metadata.icon,
#			"each_depleted_power":metadata.each_depleted_power,
#			"total_entrance_fee":metadata.total_entrance_fee,
#			"author":metadata.author,
#			"id":metadata.id,
#			"score":metadata.score,
#			"exp_reward":metadata.exp_reward,
#		}
		content_array.append({
			"metadata":metadata,
			"cid":cid
		})
	emit_signal("search_content_update",content_array.slice(begin_index,begin_index+10),begin_index)
	return 

func show_game_detail(game_id):
	var all_game_cid = cid_map.get_all_game_cid()
	for cid in all_game_cid:
		var metadata = cid_map.get_metadata(cid)
		if metadata.id == game_id:
			emit_signal("detail_update",metadata)
			return 










