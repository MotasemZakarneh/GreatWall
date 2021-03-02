extends CanvasLayer

var curr_text = ""
var status : Label
var console : Console

func _ready():
	yield(get_tree(),"idle_frame")
	var _er = NetworkHead.matchmaker_to_player.connect("on_token_compared",self,"_on_token_compared")
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
	console.write("Attempting Login")
	pass

func _on_token_compared(result):
	status.text = "Connected To Match Maker :: " + str(result)
	if result:
		$LoginContainer.visible = false
	pass
