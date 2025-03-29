extends Area2D

var is_pressed = false
var player_in_range = false

var player = null
@onready var label = $Label

func _ready():
	# Connect the area signals
	body_entered.connect(_on_body_entered)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_filedialog_show_hidden") and player_in_range:
		is_pressed = true
		on_interact()

func _on_body_entered(body):
	if body.is_in_group("SmallGuy"):
		player = body
		player_in_range = true
		label.text ="Press E"

func on_interact():
	# Visual feedback
	#$ColorRect.color = Color(0.2, 0.8, 0.2, 1)  # Change to green when pressed

	# Button press animation
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

	# Example: You can trigger events here
	#trigger_button_event()

	# Reset button after 1 second
	await get_tree().create_timer(1.0).timeout
	is_pressed = false
	#$ColorRect.color = Color(0.8, 0.2, 0.2, 1)  # Change back to red

func trigger_button_event():
	# Add your button functionality here
	# For example:
	# - Open a door
	# - Spawn an enemy
	# - Change the level
	# - Activate a trap
	# - etc.
	pass
