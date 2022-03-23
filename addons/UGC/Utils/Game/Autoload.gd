tool
extends Node

var name_map ={}

func add_autoload_dict(autoload_dict):
	for node_name in autoload_dict:
		var node_path = autoload_dict[node_name]
		add_autoload(node_name,node_path)

func add_autoload(node_name,node_path):
	var node
	match node_path.get_extension().to_lower():
		"gd":
			node = load(node_path).new()
		"tscn":
			node = load(node_path).instance()
	
	name_map[node_name] = node
	get_tree().root.call_deferred("add_child",node)
	
func get_autoload(node_name):
	return name_map[node_name]
	
func clear_autoload():
	for node_name in name_map:
		var node = name_map[node_name]
		node.queue_free()
		name_map.erase(node_name)
	name_map.clear()
