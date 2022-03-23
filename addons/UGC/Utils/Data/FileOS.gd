tool
extends Node


static func backup_export_presets():
	var d = Directory.new()
	d.copy(UGC.data_manger.data_constant.export_presets_cfg,UGC.data_manger.data_constant.export_presets_cfg_backup)

static func modify_export_presets(export_files,exclude_filter="",include_filter=""):
	var presets_cfg = ConfigFile.new()
	var err = presets_cfg.load(UGC.data_manger.data_constant.export_presets_cfg)
	var section_name
	for section in presets_cfg.get_sections():
		var platform_name = presets_cfg.get_value(section,"platform")
		if platform_name != "Windows Desktop":
			continue
		section_name = presets_cfg.get_value(section,"name")
		presets_cfg.set_value(section,"export_filter","resources")
		presets_cfg.set_value(section,"export_files",export_files)
		presets_cfg.set_value(section,"exclude_filter",exclude_filter)
		presets_cfg.set_value(section,"include_filter",include_filter)
		break 
	presets_cfg.save(UGC.data_manger.data_constant.export_presets_cfg)
	return section_name

static func restore_export_presets():
	var d = Directory.new()
	d.copy(UGC.data_manger.data_constant.export_presets_cfg_backup,UGC.data_manger.data_constant.export_presets_cfg)
	
	
	
static func backup_project():
	var d = Directory.new()
	d.copy(UGC.data_manger.data_constant.project_cfg,UGC.data_manger.data_constant.project_cfg_backup)

static func modify_project():
	var d = Directory.new()
	d.copy(UGC.data_manger.data_constant.project_cfg_default,UGC.data_manger.data_constant.project_cfg)

static func restore_project():
	var d = Directory.new()
	d.copy(UGC.data_manger.data_constant.project_cfg_backup,UGC.data_manger.data_constant.project_cfg)
	
	
	
	

static func clear_temp_path():
	remove_all_directory(UGC.data_manger.data_constant.ugc_temp_path)

static func create_temp_path():
	var d = Directory.new()
	d.open("res://")
	d.make_dir_recursive(UGC.data_manger.data_constant.ugc_temp_path)

static func copy_temp_path(folder):
	var d = Directory.new()
	d.open(UGC.data_manger.data_constant.ugc_temp_path)
	if d.dir_exists(folder):
		print("1111111111111")
		print(folder)
		copy_directory_recursively(folder,UGC.data_manger.data_constant.ugc_temp_path+"/"+folder.get_file())
	else:
		print("2222222222222")
		print(folder)
		print(folder.get_file())
		d.copy(folder,UGC.data_manger.data_constant.ugc_temp_path+"/"+folder.get_file())

static func remove_all_directory(path):
	var file_name_list = scan(path,true)
	var d = Directory.new()
	d.open("res://")
	for file_name in file_name_list:
		d.remove(file_name)

static func scan(path:String,need_dir=false) -> Array:
	var file_name := ""
	var files := []
	var dir := Directory.new()
	if dir.open(path) != OK:
		print("Failed to open:"+path)
	else:
		dir.list_dir_begin(true)
		file_name = dir.get_next()
		while file_name!="":
			if dir.current_is_dir():
				var sub_path = (path+"/"+file_name).simplify_path()
				files += scan(sub_path,need_dir)
			else:

				var cur_name := (path+"/"+file_name).simplify_path()
				files.push_back(cur_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	if need_dir:
		files.push_back(path)
	return files

static func copy_directory_recursively(p_from : String, p_to : String) -> void:
	var directory = Directory.new()
	if not directory.dir_exists(p_to):
		directory.make_dir_recursive(p_to)
	if directory.open(p_from) == OK:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while (file_name != ""):
			if directory.current_is_dir():
				copy_directory_recursively(p_from + "/" + file_name, p_to + "/" + file_name)
			else:
				if file_name.get_extension() != "import":
					directory.copy(p_from + "/" + file_name, p_to + "/" + file_name)
			file_name = directory.get_next()
	else:
		push_warning("Error copying " + p_from + " to " + p_to)


static func get_use_ugc_content(folder):
	var game_use = {}
	var file_name_list = scan(folder)
	for file_name in file_name_list:
		var cur_file_name = ProjectSettings.localize_path(file_name)
		check_use_ugc_content(cur_file_name,game_use)
	return game_use.keys()


static func check_use_ugc_content(file_name,game_use):
	if not (file_name.get_extension() in ["gd","tscn","scn"]):
		return
	var file = File.new()
	file.open(file_name,File.READ)
	var file_string = file.get_as_text()
	var regex = RegEx.new()
	
	regex.compile("\""+UGC.data_manger.data_constant.ugc_content_path+"/(?<cid>.+?)/")
	for result in regex.search_all(file_string):
		game_use[result.get_string("cid")] = true



