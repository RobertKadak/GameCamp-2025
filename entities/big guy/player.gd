extends CharacterBody2D

@export var speed = 400
@export var jump_force = -600
@export var gravity = 980
@export var smash_cooldown = 1.0  # Cooldown in seconds
@export var can_move = true  # Toggle to enable/disable movement
@export var can_attack = true  # Toggle to enable/disable attacking
@onready var animated_sprite = $AnimatedSprite2D
@onready var active_manager = get_parent()

var can_smash = true
var smash_timer = 0.0

func _physics_process(delta):
		
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle movement if enabled
	if can_move:
		handle_movement()
	
	# Handle attacks if enabled
	if can_attack:
				handle_attacks(delta)
	
	# Handle one-way platform collisions
				handle_platform_collisions()
	
				move_and_slide()

func handle_movement():
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
	
	var is_active = active_manager.active
	
	if is_active == 1:
		
		if Input.is_action_just_pressed("ui_text_indent"):
			is_active = 2
	# Get input direction
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * speed
			animated_sprite.play("walking")
			animated_sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			animated_sprite.play("idle")
		

func handle_attacks(delta):
	# Handle smash attack
	if Input.is_action_just_pressed("ui_text_indent") and can_smash:
		print('smashing')
		perform_smash()
		can_smash = false
		smash_timer = smash_cooldown
	
	# Update smash cooldown
	if not can_smash:
		smash_timer -= delta
		if smash_timer <= 0:
			can_smash = true

func perform_smash():
	# Get all bodies in the smash area
	var smash_area = $SmashArea
	var bodies = smash_area.get_overlapping_bodies()
	
	# Kill all enemies in the area
	for body in bodies:
		if body.is_in_group("Enemy"):
			body.queue_free()

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
