extends CharacterBody2D

@export var reaction_time: int = 1.0
@export var movement_speed: float = 150
@export var patrol_distance: float = 200
@export var patrol_duration: int = 1
@export var patrol_wait_time: int = 2

@onready var raycast = $RayCast2D
@onready var reaction_timer = $ReactionTime
@onready var patrol_wait_timer = $PatrolWait
@onready var area2D = $Area2D
@onready var enemy = self


var player = null
var start_pos
var left_pos
var right_pos
var moving_left = false
var animation_tween

func _ready():
	patrol_wait_timer.timeout.connect(_on_PatrolWait_timeout)
	area2D.body_entered.connect(_on_Area2D_body_entered)
	reaction_timer.timeout.connect(_on_ReactionTime_timeout)
	start_pos = enemy.position
	left_pos = start_pos - Vector2(patrol_distance / 2, 0)
	right_pos = start_pos + Vector2(patrol_distance / 2, 0)
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
	patrol() 

func patrol():	
	if animation_tween and animation_tween.is_running():
		return
	animation_tween = create_tween()
	if moving_left:
		enemy.set_scale(Vector2(1,1))
		animation_tween.tween_property(enemy, "position", left_pos, patrol_duration).set_trans(Tween.TRANS_LINEAR)
	else:
		enemy.set_scale(Vector2(-1,1))
		animation_tween.tween_property(enemy, "position", right_pos, patrol_duration).set_trans(Tween.TRANS_LINEAR)
	moving_left = !moving_left
	animation_tween.finished.connect(func():
		patrol_wait_timer.start(patrol_wait_time)
		)
