tool
extends Node

var config = ConfigFile.new()
var save_path = "res://addons/UGC/Utils/Platform/save_file.cfg"
var load_response = config.load(save_path)


func set_value(section,key,value):
	config.set_value(section,key,value)
	config.save(save_path)

	
func load_value(section,key):
	var value = config.get_value(section,key)
	return value

	
func set_metadata(cid,value):
	set_value(cid,"metadata",value)

func get_metadata(cid):
	return load_value(cid,"metadata")

func set_content_pck(cid,value):
	set_value(cid,"pck",value)
	

func get_content_pck(cid):
	return load_value(cid,"pck")


func set_game_use(cid,value):
	set_value(cid,"use",value) # 存储的为content的地址而不是pck包的地址


func get_game_use(cid):
	return load_value(cid,"use")
	
func set_type(cid,value):
	set_value(cid,"type",value)
	
func get_type(cid):
	return load_value(cid,"type")
	
func get_all_cid():
	return Array(config.get_sections())
	
func get_all_content_cid():
	var cid_array = []
	for cid in get_all_cid():
		if get_type(cid) == UGC.data_manger.data_constant.DATATYPE.CONTENT:
			cid_array.append(cid)
	return cid_array

func get_all_game_cid():
	var cid_array = []
	for cid in get_all_cid():
		if get_type(cid) == UGC.data_manger.data_constant.DATATYPE.GAME_PCK:
			cid_array.append(cid)
	return cid_array

