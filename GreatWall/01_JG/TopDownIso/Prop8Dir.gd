tool
extends Sprite
class_name Prop8Dir

enum Dir{D,T,L,R,RT,LT,RD,LD,UnAssigned}

@export(Dir) var dir = Dir.D setget set_dir
var last_dir = Dir.UnAssigned

func _ready():
	set_dir(dir)
	pass

func _process(_delta):
	if not Engine.editor_hint:
		return
	set_dir(dir)

func set_dir(new_dir):
	if new_dir == last_dir:
		return
	
	dir = new_dir
	frame = new_dir
	last_dir = dir
	pass
