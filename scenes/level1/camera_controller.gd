extends Camera2D

@export var min_zoom := 0.5
@export var max_zoom := 1.0
@export var golem_mode = true
@export var target: Node2D
@export var smooth_speed := 5.0  # Higher values = faster camera movement
@export var camera_offset = Vector2(0, 200)

func _ready() -> void:
	if golem_mode:
		zoom_golem_mode()

func _process(delta):
	if not golem_mode and target:
		# Smoothly interpolate camera position to target position
		position = position.lerp(target.position - camera_offset, smooth_speed * delta)
	else:
		# Smoothly return to center in golem mode
		position = position.lerp(Vector2(0, 0), smooth_speed * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_cat_mode()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_golem_mode()

func zoom_cat_mode():
	zoom = Vector2(1, 1)
	golem_mode = false

func zoom_golem_mode():
	zoom = Vector2(0.5, 0.5)
	golem_mode = true
