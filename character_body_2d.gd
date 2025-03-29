extends CharacterBody2D

const speed = 300
@export var jump_impulse = 400
const gravity = 980
var health = 1
var is_dead = false

# Interaction system variables
var can_interact = false
var current_interactable = null

func _ready():
	# Connect interaction area signals
	$InteractionArea.area_entered.connect(_on_interaction_area_entered)
	$InteractionArea.area_exited.connect(_on_interaction_area_exited)

func _physics_process(delta):
	if not is_dead:
		player_movement(delta)
		check_interaction()

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
	print("Player died!")
	# Restart the game after 2 seconds
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

# Interaction system functions
func check_interaction():
	if Input.is_action_just_pressed("interact") and can_interact and current_interactable != null:
		interact()

func interact():
	if current_interactable.has_method("on_interact"):
		current_interactable.on_interact(self)
	else:
		print("Interactable object has no interaction method!")

func _on_interaction_area_entered(area):
	if area.is_in_group("interactable"):
		can_interact = true
		current_interactable = area
		print("Can interact with: ", area.name)

func _on_interaction_area_exited(area):
	if area.is_in_group("interactable"):
		can_interact = false
		current_interactable = null
		print("Left interaction area") 