extends Area2D

var is_pressed = false
var player_in_range = false

var player = null

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	if Input.is_action_just_pressed("ui_filedialog_show_hidden") and player_in_range:
		is_pressed = true
		on_interact()

func _on_body_entered(body):
	if body.is_in_group("SmallGuy"):
		player = body
		player_in_range = true


func on_interact():
	if player:
		player.queue_free()
		get_parent().active_manager.control_cat = false
		get_parent().to_play_idle = "idleWithCat"
		get_parent().to_play_walking = "walkWithCat"
		get_parent().animated_sprite.play("idleWithCat") 
