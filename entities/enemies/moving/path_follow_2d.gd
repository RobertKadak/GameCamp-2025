extends PathFollow2D

@export var patrol_speed: float = 30
@export var wait_time: float = 1.5

var moving = true
var waiting = false

@onready var wait_timer = $Timer
@onready var path = $PathFollow2D
@onready var node = $CharacterBody2D

func _ready():
	node.set_rotation_degrees(0)
	wait_timer.wait_time = wait_time
	wait_timer.one_shot = true
	wait_timer.timeout.connect(_on_Timer_timeout)

func _process(delta: float) -> void:
	if waiting:
		return

	if moving:
		progress += patrol_speed * delta
		if progress_ratio >= 1.0:
			moving = false
			wait_at_point()
	else:
		progress -= patrol_speed * delta
		if progress_ratio <= 0.0:
			moving = true
			wait_at_point()

func wait_at_point():
	waiting = true
	wait_timer.start()

func _on_Timer_timeout():
	waiting = false
