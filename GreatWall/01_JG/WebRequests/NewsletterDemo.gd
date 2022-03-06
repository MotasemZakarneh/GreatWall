extends Node2D
@export var api_key = ""
@export var audience_id = ""
@export var email = "godotTest@jondobgames.com"
@export(Array,String) var tags = []

func _ready():
	print("Sending Request")
	await get_tree().idle_frame
	var r = yield(WebRequests.send_email_async($HTTPRequest,email,tags,api_key,audience_id),"completed")
	print("Request Result is " + str(r["result"]) + " with msg " + r["msg"])
	pass
