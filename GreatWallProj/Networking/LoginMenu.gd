extends CanvasLayer

var curr_text = ""
var status : Label
var console : Console

func _ready():
	yield(get_tree(),"idle_frame")
	var _er = NetworkHead.matchmaker_to_player.connect("on_connected_to_match_maker",self,"_on_connected_to_match_maker")
	_er = NetworkHead.gateway_to_player.connect("on_verfication_completed",self,"_on_verfication_completed")
	status = get_node("Status")
	status.text = "Not Logged In"
	console = ConsoleLoader.get_main(self)
	pass

func _on_LineEdit_text_changed(new_text):
	curr_text = new_text
	pass

func _on_Button_button_up():
	if curr_text == "":
		return
	
	NetworkHead.gateway_to_player.on_login_clicked(curr_text,"")
	status.text = "Attempting Login"
	console.write_line("Attempting Login")
	pass

func _on_verfication_completed(result):
	var msg = "Verfication Completed Result : " + str(result)
	status.text = msg
	console.write_line(msg)
	pass

func _on_connected_to_match_maker():
	status.text = "Connected To Match Maker"
	console.write_line(status.text)
	$LoginContainer.visible = false
	pass
