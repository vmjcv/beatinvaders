tool
extends Reference

var fileos = load("res://addons/UGC/Utils/Data/FileOS.gd").new()

func ugc_package(folder,metadata_dict):
	fileos.clear_temp_path() # 清空原先的文件
	fileos.create_temp_path()
	fileos.copy_temp_path(folder)
	_create_license(metadata_dict.license,metadata_dict)
	var metadata_format = {
		"title":"{title}".format(metadata_dict),
		"type":"{type}".format(metadata_dict),
		"dict":"{dict}".format(metadata_dict),
		"tag":"{tag}".format(metadata_dict),
		"license":"{license}".format(metadata_dict),
		"desc":"{desc}".format(metadata_dict),
		"version":"{version}".format(metadata_dict),
		"screenshot":"{screenshot}".format(metadata_dict),
		"hash":UGC.data_manger.crypto.encrypt(UGC.data_manger.crypto_key, metadata_dict["author"].to_utf8())
	}
	_create_metadata_json(metadata_format)


func _create_license(license,license_data):
	var fp_LICENSE:File = File.new()
	fp_LICENSE.open(UGC.data_manger.data_constant.ugc_temp_path+"/LICENSE.txt",File.WRITE)
	var license_str
	if not license_data.has("year"):
		license_data["year"] = OS.get_datetime()["year"]
	if not license_data.has("author"):
		license_data["author"] = "Slime MetaWorld"

	match license:
		"MIT":
			license_str = UGC.data_manger.data_constant.MIT_license.format(license_data)
		"CC0":
			license_str = UGC.data_manger.data_constant.CC0_license.format(license_data)
		"SBAU":
			license_str = UGC.data_manger.data_constant.SBAU_license.format(license_data)
	fp_LICENSE.store_string(license_str)
	fp_LICENSE.close()

func _create_metadata_json(metadata_json):
	var fp_metadata:File = File.new()
	fp_metadata.open(UGC.data_manger.data_constant.ugc_temp_path+"/metadata.json",File.WRITE)
	var json_string = JSON.print(metadata_json)
	fp_metadata.store_string(json_string)
	fp_metadata.close()
