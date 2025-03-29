extends CharacterBody2D

@export var vision_range: float = 200
@export var reaction_time: float = 1.0
@export var movement_speed: float = 150
@export var patrol_distance: float = 100

@onready var raycast = $RayCast2D
@onready var reaction_timer = $ReactionTime
@onready var patrol_wait_timer = $PatrolWait
@onready var area2D = $Area2D
@onready var enemy = self


var player = null

func _ready():
	area2D.body_entered.connect(_on_Area2D_body_entered)
	reaction_timer.timeout.connect(_on_ReactionTime_timeout)
	patrol()

#CHECK IF SMALL GUY IS WITHIN GETTING-FUCKED RANGE OF ENEMY
func _on_Area2D_body_entered (body):
	if body.is_in_group("SmallGuy"):
		player = body
		check_line_of_sight()

#Checking if line of sight is obstructed (player wont get fucked behind walls)
func check_line_of_sight():
	if player:
		raycast.target_position = player.global_position - global_position
		raycast.force_raycast_update()
		if  !raycast.is_colliding() or raycast.get_collider() == player:
			reaction_timer.start(reaction_time)

#Reaction time of enemy
func _on_ReactionTime_timeout():
	if player:
		player.die()

func _on_PatrolWait_timeout():
	pass 

func patrol():	
	var animation_tween = create_tween()
	var duration = 2
	var start_pos = enemy.position
	var left_point = start_pos - Vector2(patrol_distance, 0)
	var right_point = start_pos + Vector2(patrol_distance,0)
	
	animation_tween.tween_property(enemy, "position", left_point, duration).set_trans(Tween.TRANS_LINEAR)
	animation_tween.tween_property(enemy, "position", right_point, duration).set_trans(Tween.TRANS_LINEAR)
	animation_tween.set_loops()
