extends CanvasLayer

@export var def_dur = 3
@export var def_out_color : Color
@export var def_in_color : Color

signal on_faded
signal on_faded_in
signal on_faded_out

var start_mouse_filter = Control.MOUSE_FILTER_IGNORE
var tween : Tween = null

func _ready():
	start_mouse_filter = $ColorRect.mouse_filter
	tween = create_tween()
	tween.stop()
	pass

func inst_fade_in():
	$ColorRect.color = def_in_color
	$ColorRect.mouse_filter = start_mouse_filter
	
	await get_tree().idle_frame
	emit_signal("on_faded")
	emit_signal("on_faded_out")
	pass

func inst_fade_out():
	$ColorRect.color = def_out_color
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	await get_tree().idle_frame
	emit_signal("on_faded")
	emit_signal("on_faded_in")
	pass

func fade_out(dur,out_color):
	tween.tween_property($ColorRect,"color",out_color,dur).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.start()
	await get_tree().create_timer(dur+0.01).timeout
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	emit_signal("on_faded")
	emit_signal("on_faded_out")
	pass

func fade_in(dur,in_color):
	tween.tween_property($ColorRect,"color",in_color,dur).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.start()
	await get_tree().create_timer(dur+0.01).timeout
	$ColorRect.mouse_filter = start_mouse_filter
	emit_signal("on_faded")
	emit_signal("on_faded_in")
	pass

func def_fade_in():
	fade_in(def_dur,def_in_color)
	pass

func def_fade_out():
	fade_out(def_dur,def_out_color)
	pass
