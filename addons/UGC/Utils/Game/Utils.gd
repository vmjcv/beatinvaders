tool
extends Node

func remove_all_child(panrent_node):
	for node in panrent_node.get_children():
		panrent_node.remove_child(node)

func change_y_to_windoiw(node):
	var node_rect = node.get_global_rect()
	if node_rect.position.y < 0:
		node.rect_global_position.y = 0
	if node_rect.end.y > OS.window_size.y:
		node.rect_global_position.y -= (node_rect.end.y-OS.window_size.y)
	
	
func remove_all_child_begin_index(panrent_node,begin_index):
	for node in panrent_node.get_children():
		if node.get_index()>=begin_index:
			panrent_node.remove_child(node)


