extends Node2D

@onready var active = 1


func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_focuse_next"):
		if active != 3:
			active += 1
		else:
			active = 1
			
	pass
