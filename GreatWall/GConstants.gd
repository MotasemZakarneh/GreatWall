extends Node
class_name GConstants

const server_data_dir_name = "GWServerData"
const worlds_builder_file = "WorldsBuilder.json"
const statics_file_name = "StaticData.json"
const dynamics_file_name = "DynamicData.json"
const matches_file_name = "MatchesData.json"

static func get_server_data_dir():
	return Extentions.get_user_dir(server_data_dir_name)
