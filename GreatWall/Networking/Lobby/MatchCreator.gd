extends Control

var curr_match_name = ""
var curr_match_pw = ""
var curr_match_desc = ""

func _ready():
	var _er = $VBox/MatchName.connect("on_text_updated",self,"_set_match_name")
	_er = $VBox/MatchPW.connect("on_text_updated",self,"_set_match_pw")
	_er = $VBox/MatchDesc.connect("on_text_updated",self,"_set_match_desc")
	
	curr_match_name = $VBox/MatchName.curr_text
	curr_match_pw = $VBox/MatchPW.curr_text
	curr_match_desc = $VBox/MatchDesc.curr_text
	
	_er = $VBox/CreateMatch.connect("button_up",self,"_on_create_clicked")
	pass

func _set_match_name(new_text):
	curr_match_name = new_text
	pass

func _set_match_pw(new_text):
	curr_match_pw = new_text
	pass

func _set_match_desc(new_text):
	curr_match_desc = new_text
	pass

func _on_create_clicked():
	NetworkHead.matchmaker_to_player.cs_create_match(curr_match_name,curr_match_pw,curr_match_desc)
	pass
