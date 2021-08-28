extends HBoxContainer

export(NodePath) var match_name_label_path
export(NodePath) var players_label_path
export(NodePath) var privacy_label_path
export(NodePath) var map_label_path

var match_name_label : RichTextLabel = null
var players_label : RichTextLabel = null
var privacy_label : RichTextLabel = null
var map_label : RichTextLabel = null

var match_id
var match_name
var curr_players
var max_players
var privacy
var map

func setup(_match_id,_match_name,_curr_players,_max_players,_privacy,_map):
	match_name_label = get_node(match_name_label_path)
	players_label = get_node(players_label_path)
	privacy_label = get_node(privacy_label_path)
	map_label = get_node(map_label_path)
	
	match_id = _match_id
	match_name = _match_name
	curr_players = _curr_players
	max_players = _max_players
	privacy = _privacy
	map = _map
	
	match_name_label.bbcode_text = Extentions.get_centered_bbtext(_match_name)
	players_label.bbcode_text = Extentions.get_centered_bbtext(str(_curr_players)+"/"+str(_max_players))
	privacy_label.bbcode_text = Extentions.get_centered_bbtext(str(_privacy))
	map_label.bbcode_text = Extentions.get_centered_bbtext(str(_map))
	pass
