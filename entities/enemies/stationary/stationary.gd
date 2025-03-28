extends CharacterBody2D

@export var vision_range: float = 200
@export var reaction_time: float = 1.0

@onready var raycast = $RayCast2D
@onready var reaction_timer = $Timer
@onready var area2D = $Area2D


var player = null

func _ready():
	area2D.body_entered.connect(_on_Area2D_body_entered)
	reaction_timer.timeout.connect(_on_Timer_timeout)

#CHECK IF SMALL GUY IS WITHIN GETTING-FUCKED RANGE OF ENEMY
func _on_Area2D_body_entered (body):
	if body.is_in_group("SmallGuy"):
		player = body
		check_line_of_sight()

func check_line_of_sight():
	if player:
		raycast.target_position = player.global_position - global_position
		raycast.force_raycast_update()
		if  !raycast.is_colliding() or raycast.get_collider() == player:
			reaction_timer.start(reaction_time)

func _on_Timer_timeout():
	if player:
		player.die()
