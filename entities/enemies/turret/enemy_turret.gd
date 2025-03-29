extends StaticBody2D

@export var reaction_time: int  = 1

@onready var reaction_timer = $Area2D/ReactionTime
@onready var raycast = $Area2D/RayCast2D
@onready var area2D = $Area2D

var player = null

func _ready():
	reaction_timer.timeout.connect(_on_ReactionTime_timeout)
	area2D.body_entered.connect(_on_Area2D_body_entered)
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("SmallGuy"):
		player = body
		check_line_of_sight()

func check_line_of_sight():
	if player:
		raycast.target_position = player.global_position - global_position
		raycast.force_raycast_update()
		if  !raycast.is_colliding() or raycast.get_collider() == player:
			reaction_timer.start(reaction_time)

func _on_ReactionTime_timeout():
	if player:
		player.die()
