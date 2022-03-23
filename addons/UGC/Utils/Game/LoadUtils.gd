tool
extends Node

func load_tex(node,path):
	_load_tex(node,path)

func _load_tex(node,path,need_download=true):
	if (not need_download) or ResourceLoader.exists(path):
#		print("load texture:",path)
		node.texture = ResourceLoader.load(path)
	else:
		var content_cid = get_ipfs_id(path)
		if not content_cid:
			# 缺省的文件，先直接返回把
			return
		var content_pck_path = UGC.data_manger.data_constant.ugc_content_pck_path+"/%s.pck"%content_cid
		var file = File.new()
		if file.file_exists(content_pck_path):
			ProjectSettings.set_load_pack_enabled(true)
			ProjectSettings.load_resource_pack(content_pck_path)
			_load_tex(node,path,false)
		else:
			var pck_cid = UGC.platform_protocol.get_content_info(content_cid).pck
			UGC.data_manger.content_pck_download.ugc_download(pck_cid,content_cid)
			yield(UGC.data_protocol,"cid-%s"%pck_cid)
			ProjectSettings.set_load_pack_enabled(true)
			ProjectSettings.load_resource_pack(content_pck_path)
			_load_tex(node,path,false)

func get_ipfs_id(path):
	var regex = RegEx.new()
	regex.compile(UGC.data_manger.data_constant.ugc_content_path+"/(?<cid>.+?)/")
	var result = regex.search(path)
	if result:
		return result.get_string("cid")
	return false
