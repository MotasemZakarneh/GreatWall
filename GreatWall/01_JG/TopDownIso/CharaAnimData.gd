extends Resource
class_name CharaAnimData

enum AnimDirs {Four = 4,Eight = 8}

@export(Array,Texture) var texes
@export(Array,Vector2) var texes_lengths
@export (AnimDirs) var directions_to_get = AnimDirs.Eight
@export(Array,float) var speeds
