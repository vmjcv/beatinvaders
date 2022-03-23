tool
extends Node
signal upload_file_result
signal download_file_result
var need_upload_pck={}

func _ready():
	yield(get_tree().root.get_child(get_tree().root.get_child_count()-1), "ready")
	var nodejs_client = UGC.nodejs_client
	var nodejs_constant = UGC.nodejs_client.nodejs_constant
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_UPLOAD_FILE,[self,"upload_file_result"])
	nodejs_client.server_call_register(nodejs_constant.PROTOCOL.S_C_DOWNLOAD_FILE,[self,"download_file_result"])

func upload_file_result(data):
	var cid = data[0]
	var type = data[1]
	var content_cid = data[2]
	var data_constant = UGC.data_manger.data_constant
	emit_signal("upload_file_result",cid,type,content_cid)
#	match type:
#		data_constant.DATATYPE.CONTENT:
#			UGCContentDownload.new().ugc_download(cid)
#			need_upload_pck[cid] = true
#		data_constant.DATATYPE.CONTENT_PCK:
#			# 上传成功content与pck文件后进行存储原始信息,应迁移到网络端去存储
#			var folder = UGCMap.ipfs_map[content_cid]["folder"]
#			folder = ProjectSettings.localize_path(folder)+"/metadata.json"
#			var fp_metadata:File = File.new()
#			fp_metadata.open(folder,File.READ)
#			var json_string = fp_metadata.get_as_text()
#			fp_metadata.close()
#			CIDMapSave.set_content_metadata(content_cid,JSON.parse(json_string).result)
#			CIDMapSave.set_content_pck(content_cid,cid)
#			CIDMapSave.set_type(content_cid,UGCMap.DATATYPE.CONTENT)
#			# UGCPckDownload.new().ugc_download(cid)
#			pass
#		data_constant.DATATYPE.GAME_PCK:
##			CIDMapSave.set_game_metadata(cid,json.get_data())
#			CIDMapSave.set_game_use(cid,UGCMap.game_use)
#			CIDMapSave.set_type(cid,UGCMap.DATATYPE.GAME_PCK)
#			# UGCGameDownload.new().ugc_download(cid)
#			pass
	pass

func download_file_result(data):
	var cid = data[0]
	var type = UGC.data_manger.get_ipfs(cid)["type"]
	var folder = UGC.data_manger.get_ipfs(cid)["folder"]
	emit_signal("download_file_result",cid, type,folder)
#	match type:
#		UGCMap.DATATYPE.CONTENT:
#			UGCContentUnpackage.new().ugc_unpackage(folder)
#			pass
#		UGCMap.DATATYPE.CONTENT_PCK:
#			UGCPckUnpackage.new().ugc_unpackage(folder)
#			pass
#		UGCMap.DATATYPE.GAME_PCK:
#			UGCGameUnpackage.new().ugc_unpackage(folder)
#
#	if need_upload_pck.get(cid,false):
#		UGCPckUpload.new().ugc_upload({"folder":folder,"content_cid":cid})
#		need_upload_pck[cid] = false

	if has_user_signal("cid-%s"%cid):
		emit_signal("cid-%s"%cid)


func upload(path,type,content_cid=1):
	var data = []
	data.append(UGC.data_manger.token)
	data.append(path)
	data.append(type)
	data.append(content_cid)
	UGC.nodejs_client.call_server(UGC.nodejs_client.nodejs_constant.PROTOCOL.C_S_UPLOAD_FILE,data)

func download(res_cid,path):
	var data = []
	data.append(UGC.data_manger.token)
	data.append(res_cid)
	data.append(path)
	UGC.nodejs_client.call_server(UGC.nodejs_client.nodejs_constant.PROTOCOL.C_S_DOWNLOAD_FILE,data)
	var signal_name = "cid-%s"%res_cid
	if not has_user_signal(signal_name):
		add_user_signal(signal_name)

