tool
extends Reference
var fileos = load("res://addons/UGC/Utils/Data/FileOS.gd").new()


func ugc_package():
	fileos.clear_temp_path() # 清空原先的文件
	fileos.create_temp_path()
	_create_input()
	create_pck_begin()
	
	
func create_pck_begin():
	fileos.backup_export_presets()
	var folder = UGC.data_manger.data_constant.ugc_game_path
	var file_name_list = fileos.scan(folder)
	var addons_folder = "res://addons"
	var addon_name_list = fileos.scan(addons_folder)
	var channel = fileos.modify_export_presets(PoolStringArray(file_name_list+addon_name_list),"addons/UGC/*","")
	var output = []
	var pck_folder = UGC.data_manger.data_constant.ugc_temp_globalize_path+"/UGCGame.pck"
	var array = ["--export-pack", str(channel),pck_folder]
	var args = PoolStringArray(array)
	OS.execute(OS.get_executable_path(), args, true, output)
	create_pck_end()
	

func create_pck_end():
	fileos.restore_export_presets()


func _create_input():
	var input_folder = ConfigFile.new()
	input_folder.load(UGC.data_manger.data_constant.ugc_game_input_path)
	input_folder.clear()
	
	var project_folder = ConfigFile.new()
	project_folder.load("res://project.godot")
#	for action in InputMap.get_actions():# 这个读的内容不对，读project.godot的内容把
	for action in project_folder.get_section_keys("input"):
		var data = project_folder.get_value("input",action)
		input_folder.set_value("Input",action,data.events)
		input_folder.set_value("Deadzone",action,data.deadzone)
	input_folder.save(UGC.data_manger.data_constant.ugc_game_input_path)
