tool
extends Node

var class_map ={}

func add_classname_dict(classname_dict):
	for class_base_name in classname_dict:
		var class_path = classname_dict[class_base_name]
		add_classname(class_base_name,class_path)

func add_classname(class_base_name,class_path):
	var class_node = ResourceLoader.load(class_path)
	class_map[class_base_name] = class_node
	
func get_classname(class_base_name):
	return class_map[class_base_name]
	
func clear_classname():
	for class_base_name in class_map:
		var class_node = class_map[class_base_name]
		class_map.erase(class_node)
	class_map.clear()
