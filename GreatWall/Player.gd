extends KinematicBody2D

export(Array,Resource) var anim_sets
export var chara_name = "MC"
export var speed = 150
export var active_set = "3"

var animator : IsoCharaAnimator
var input_reader : MoveInputReader

func _ready():
	animator = get_node("IsoCharaAnimator")
	input_reader = get_node("MoveInputReader")
	animator.setup_anims(chara_name,anim_sets,active_set)
	animator.play_anim("Idle")
	pass

func _process(_delta):
	animator.set_active_anim_set(active_set)
	animator.update_dir(input_reader.last_non_zero_input_safe)
	var i : Vector2 = input_reader.input
	var anim = "Idle"
	
	if i.length()>0.1:
		var _v = move_and_slide(i*speed)
		anim = "Run"
	
	animator.play_anim(anim)
	pass
