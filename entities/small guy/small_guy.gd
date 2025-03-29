extends CharacterBody2D

const speed = 300
@export var jump_impulse = 400
const gravity = 980
var is_dead = false
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	if not is_dead:
		player_movement(delta)
	
	# Handle one-way platform collisions
	handle_platform_collisions()
	
	move_and_slide()

func handle_platform_collisions():
	# If moving down and pressing down, disable collision with platforms
	if Input.is_action_pressed("ui_down"):
		# Get all bodies we're colliding with
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("Platform"):
				# Disable collision with this specific platform
				collider.set_collision_layer_value(1, false)
	else:
		# Re-enable collision with all platforms
		for platform in get_tree().get_nodes_in_group("Platform"):
			platform.set_collision_layer_value(1, true)

func player_movement(delta): 
	if Input.is_action_pressed("ui_right"):
		animated_sprite.play("walking")
		velocity.x = speed 
	elif Input.is_action_pressed("ui_left"):
		animated_sprite.play("walking")
		velocity.x = -speed
	else:
		velocity.x = 0
		animated_sprite.play("Idle")
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = -jump_impulse

func die():
	is_dead = true
	velocity = Vector2.ZERO
	queue_free()
