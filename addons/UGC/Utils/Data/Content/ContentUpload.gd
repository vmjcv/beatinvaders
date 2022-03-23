tool
extends Reference


var ugc_content_package = load("res://addons/UGC/Utils/Data/Content/ContentPackage.gd").new()

func ugc_upload(args):
	print(args)
	ugc_content_package.ugc_package(args["folder"],args["metadata_dict"])
	var path = UGC.data_manger.data_constant.ugc_temp_globalize_path
	UGC.data_protocol.upload(path,UGC.data_manger.data_constant.DATATYPE.CONTENT,1)
