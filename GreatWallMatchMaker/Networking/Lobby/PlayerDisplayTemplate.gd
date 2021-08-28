extends Control

var port = 0
var key = ""
var player = ""

func setup(_player,_address,_port):
	player = _player
	key = _address
	port = _port
	
	$RichTextLabel.bbcode_text = "[center]" + str(key) + " :: " + str(port) + "[/center]"
	pass

func setup_by_name(_player,_player_name):
	player = _player
	key = _player_name
	port = 0
	
	$RichTextLabel.bbcode_text = "[center]" + str(key) + "[/center]"
	pass

func is_owned_by(_player):
	return _player == player
