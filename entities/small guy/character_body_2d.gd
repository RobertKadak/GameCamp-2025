extends CharacterBody2D

const speed = 300
@export var jump_impulse = 400
const gravity = 980
var health = 1
var is_dead = false

func _physics_process(delta):
	if not is_dead:
		player_movement(delta)

func player_movement(delta): 
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed 
	elif Input.is_action_pressed("ui_left"): 
		velocity.x = -speed
	else:
		velocity.x = 0
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_impulse
	
	move_and_slide()

func take_damage():
	if not is_dead:
		health -= 1
		if health <= 0:
			die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
