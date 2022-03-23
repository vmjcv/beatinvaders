tool
extends Reference

func ugc_download(res_cid):
	var path = ProjectSettings.globalize_path(UGC.data_manger.data_constant.ugc_game_pck_path+"/%s"%res_cid)
	var game_pck_path = ProjectSettings.globalize_path(UGC.data_manger.data_constant.ugc_game_pck_path+"/%s/UGCGame.pck"%res_cid)
	UGC.data_manger.add_ipfs(res_cid,game_pck_path,UGC.data_manger.data_constant.DATATYPE.GAME_PCK)
	UGC.data_protocol.download(res_cid,path)
