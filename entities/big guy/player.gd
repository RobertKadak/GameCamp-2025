extends CharacterBody2D

@export var speed = 400
@export var jump_force = -600
@export var gravity = 980
@onready var animated_sprite = $AnimatedSprite2D
@onready var active_manager = get_parent()

var cat_on_golem = false

var to_play_idle
var to_play_walking

func _ready():
	to_play_idle = "idle"
	to_play_walking = "walking"
	
	# Disable collision with SmallGuy
	get_tree().get_nodes_in_group("SmallGuy")[0].set_collision_layer_value(1, false)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	handle_platform_collisions()
	if !active_manager.control_cat:
		handle_movement()
		move_and_slide()


func handle_movement():
	# Get input direction
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		animated_sprite.play(to_play_walking)
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		animated_sprite.play(to_play_idle)
		
	#CAT GET OFF
	if Input.is_action_just_pressed("ui_filedialog_show_hidden"):
			var small_guy_scene = preload("res://entities/small guy/small_guy.tscn")
			var small_guy = small_guy_scene.instantiate()
			small_guy.position = self.position
			small_guy.z_index = 2
			self.get_parent().add_child(small_guy)
			to_play_idle = "idle"
			to_play_walking = "walking"
			animated_sprite.play(to_play_idle)
			active_manager.control_cat = true
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
