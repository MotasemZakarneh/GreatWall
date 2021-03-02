extends Node
class_name PortsHelper

const worlds_start_port = 1950
var console : Console

func _ready():
	console = ConsoleLoader.get_main(self)
	pass

func get_first_clean_port(data):
	var port = worlds_start_port + data.size()
	var used_ports = get_used_ports(data)
	
	if not used_ports.has(port):
		return port
	
	var highest_port = get_highest_port(used_ports)
	var diff = highest_port - worlds_start_port
	
	for i in range(diff):
		var test_port = worlds_start_port + i
		if used_ports.has(test_port):
			continue
		port = test_port
		break
	
	return port

func get_highest_port(used_ports):
	var highest_port = 0
	
	for p in used_ports:
		if p >= highest_port:
			highest_port = p
	
	return highest_port

func get_used_ports(data):
	var used_ports = []
	for d in data:
		var m = data[d]
		var used_port = int(m["port"])
		used_ports.append(used_port)
	return used_ports
