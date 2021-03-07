extends Object
class_name MatchesGroup

var matches_names : Array = []
var matches_data : Dictionary = {}
	
func contains(match_name)->bool:
	return matches_names.has(match_name)

func add_match(match_data):
	var n = match_data["match_name"]
	if contains(n):
		return
	
	matches_names.append(n)
	matches_data[n] = match_data
	pass

func remove_match(match_name):
	if not contains(match_name):
		return
	
	matches_names.erase(match_name)
	var _er = matches_data.erase(match_name)
	pass

func pop_match()->Dictionary:
	if matches_names.size()==0:
		return {}
	
	var n = matches_names[0]
	var n_data = matches_data[n]
	
	matches_names.remove(0)
	var _er = matches_data.erase(n)
	
	return n_data

func pop_match_of_name(match_name)->Dictionary:
	if not contains(match_name):
		return {}
	var n_data = matches_data[match_name]
	remove_match(match_name)
	return n_data
