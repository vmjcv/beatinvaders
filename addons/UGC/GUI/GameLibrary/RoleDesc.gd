tool
extends TabContainer


var init_desc setget set_init_desc
var use_desc setget set_use_desc

func set_init_desc(val):
	init_desc = val
	$InitDesc.text = val
	
func set_use_desc(val):
	use_desc = val
	$UseDesc.text = val
