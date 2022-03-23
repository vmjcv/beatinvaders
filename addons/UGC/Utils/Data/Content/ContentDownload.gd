tool
extends Reference

func ugc_download(res_cid):
	var path = ProjectSettings.globalize_path(UGC.data_manger.data_constant.ugc_content_path+"/"+res_cid)
	UGC.data_manger.add_ipfs(res_cid,path,UGC.data_manger.data_constant.DATATYPE.CONTENT)
	UGC.data_protocol.download(res_cid,path)
	printt("download",res_cid,path)

