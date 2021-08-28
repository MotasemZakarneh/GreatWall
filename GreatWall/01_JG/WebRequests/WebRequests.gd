extends Node
class_name WebRequests

static func send_email_async(caller:HTTPRequest,email:String,tags:Array,api_key:String,audience_id:String):
	yield(caller.get_tree(),"idle_frame")
	var url = build_chimp_url(api_key,audience_id)
	var result = false
	var msg = ""
	var r = {
		"result":result,
		"msg" : msg
	}
	
	if url == null || url == "":
		msg = "MailChimp — Invalid API Key format"
		print(msg)
		r["msg"] = msg
		return r
	
	if email == null or email == "" or email.find('@') < 1:
		msg = "MailChimp - Invalid Email";
		r["msg"] = msg
		return r
	
	r = yield(_send_email_request_async(caller,api_key,url,email,tags),"completed")
	
	return r

static func build_chimp_url(api_key:String,audience_id:String):
	#Original
	#var url_form = "https://{0}.api.mailchimp.com/3.0/lists/{1}/members";
	var url_form = "https://%s.api.mailchimp.com/3.0/lists/%s/members"
	
	var seperator_index = api_key.find('-')
	if seperator_index<0:
		return null
	
	var url_prefix = api_key.substr(seperator_index + 1)
	if url_prefix == "":
		return null
	
	var url = url_form % [url_prefix,audience_id]
	return url

static func _send_email_request_async(caller:HTTPRequest,api_key,url,email,tags:Array):
	yield(caller.get_tree(),"idle_frame")
	var auth_api = "Authorization: apikey " +api_key
	
	var headers = [
		"Content-Type: application/json",
		auth_api
	]
	#Original
	#var json_string = "{{\"email_address\":\"{0}\", \"status\":\"subscribed\"}}"
	#var json_string = "{\"email_address\":\"%s\", \"status\":\"subscribed\"}"
	if tags == null:
		tags = []
	
	var data = {
		"email_address":email,
		"status":"subscribed",
		"tags":tags
	}
	var json_string = Extentions.to_pretty_json(data)
	
	var er = caller.request(url,headers,true,HTTPClient.METHOD_POST,json_string)
	yield(caller,"request_completed")
	var msg = "MailChimp - Failed To Send Request"
	
	if er == OK:
		msg = "MailChimp - Email Sent Sucessfully"
	
	var r = {
		"result":er == OK,
		"msg":msg
	}
	return r
