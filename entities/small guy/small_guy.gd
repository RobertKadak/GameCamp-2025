extends CharacterBody2D

const speed = 300
@export var jump_force = 400
const gravity = 980
var is_dead = false
@onready var animated_sprite = $AnimatedSprite2D
@onready var active_manager = get_parent()

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
	var is_active = active_manager.active
	
	if is_active == 2:
	# Handle jump
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_force
	
	# Get input direction
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		animated_sprite.play("walking")
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		animated_sprite.play("idle")

func die():
	is_dead = true
	velocity = Vector2.ZERO
	queue_free()
