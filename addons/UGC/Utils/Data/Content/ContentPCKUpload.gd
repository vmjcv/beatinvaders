tool
extends Reference


var ugc_content_pck_package = load("res://addons/UGC/Utils/Data/Content/ContentPCKPackage.gd").new()


func ugc_upload(args):
	ugc_content_pck_package.ugc_package(args["folder"])
	var content_cid = args["folder"].split("/",false)[-1]
	var path = UGC.data_manger.data_constant.ugc_temp_globalize_path
	UGC.data_protocol.upload(path,UGC.data_manger.data_constant.DATATYPE.CONTENT_PCK,content_cid)
