extends Node2D

var control_cat

func _ready():
	control_cat = true

func _process(delta):
	if Input.is_action_just_pressed("ui_text_indent"):
		control_cat = !control_cat
