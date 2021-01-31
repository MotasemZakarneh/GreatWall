extends Node2D


func _process(_delta):
	if Input.is_action_just_released("ui_accept"):
		var gateway_to_player = NetworkHead.gateway_to_player
		gateway_to_player.on_login_clicked("TEst","WTF")
	pass
