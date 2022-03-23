tool
extends Node

func load_input():
	InputMap.load_from_globals()
	var input_folder = ConfigFile.new()
	input_folder.load(UGC.data_manger.data_constant.ugc_game_input_path)
	
	for action in input_folder.get_section_keys("Input"):
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		var deadzone = input_folder.get_value("Deadzone",action)
		InputMap.action_set_deadzone(action,deadzone)
		var value = input_folder.get_value("Input",action)
		for event in value:
			InputMap.action_add_event(action,event)

