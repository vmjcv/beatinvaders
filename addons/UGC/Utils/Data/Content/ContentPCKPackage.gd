tool
extends Reference
var fileos = load("res://addons/UGC/Utils/Data/FileOS.gd").new()


func ugc_package(folder):
	fileos.clear_temp_path() # 清空原先的文件
	fileos.create_temp_path()
	create_pck_begin(folder)
	
	
func create_pck_begin(folder):
	fileos.backup_export_presets()
	var file_name_list = fileos.scan(folder)
	print(file_name_list)
	var channel = fileos.modify_export_presets(PoolStringArray(file_name_list),"addons/UGC/*","")
	
	fileos.backup_project()
	fileos.modify_project()

	var output = []
	var ipfs_cid = folder.split("/",false)[-1]
	var pck_folder = UGC.data_manger.data_constant.ugc_temp_globalize_path+"/%s.pck"%ipfs_cid
	var array = ["--export-pack", str(channel),pck_folder]
	var args = PoolStringArray(array)
	OS.execute(OS.get_executable_path(), args, true, output)
	create_pck_end()
	
func create_pck_end():
	fileos.restore_export_presets()
	fileos.restore_project()



