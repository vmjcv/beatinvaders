tool
extends Reference
var fileos = load("res://addons/UGC/Utils/Data/FileOS.gd").new()

var ugc_game_pck_package = load("res://addons/UGC/Utils/Data/Game/GamePCKPackage.gd").new()

func ugc_upload():
	ugc_game_pck_package.ugc_package()
	var path = UGC.data_manger.data_constant.ugc_temp_globalize_path
	UGC.data_protocol.upload(path,UGC.data_manger.data_constant.DATATYPE.GAME_PCK,1)


func get_use_array():
	return fileos.get_use_ugc_content(UGC.data_manger.data_constant.ugc_game_path)
