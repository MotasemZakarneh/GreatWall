extends HBoxContainer

export var def_name = "Match Name"
export var def_priv = "Is Private"

func _ready():
	$NameLabel.text = def_name
	$PrivLabel.text = def_priv
	pass

func set_match(match_data):
	if match_data.size()==0:
		return
	$NameLabel.text ="matc"
	pass

func update_match_stat(match_data):
	
	pass
