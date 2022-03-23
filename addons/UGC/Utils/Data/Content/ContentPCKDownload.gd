tool
extends Reference

func ugc_download(res_cid,content_cid):
	var path = UGC.data_manger.data_constant.ugc_content_pck_globalize_path
	var content_pck_path =  ProjectSettings.globalize_path(UGC.data_manger.data_constant.ugc_content_pck_path+"/%s.pck"%content_cid)
	UGC.data_manger.add_ipfs(res_cid,content_pck_path,UGC.data_manger.data_constant.DATATYPE.CONTENT_PCK)
	UGC.data_protocol.download(res_cid,path)
