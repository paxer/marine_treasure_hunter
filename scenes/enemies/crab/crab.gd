extends KinematicBody2D

onready var sprite_size = get_node("Sprite").get_texture().get_size()
onready var screen_size = get_viewport_rect().size

var speed
var moving_from_left_to_right = false

func _ready():
	set_initial_position()
	set_fixed_process(true)

func set_initial_position():
	randomize()
	speed = int(rand_range(50, 150))
	# the crab can start moving from the left or right sides of the screen bottom
	var start_from_left = Vector2(-sprite_size.x, screen_size.y - 96)
	var start_from_right = Vector2(screen_size.x + sprite_size.x, screen_size.y - 96)
	var initial_position
	# 50% chance to move from right or left
	if randf() > 0.5:
		moving_from_left_to_right = true
		set_pos(start_from_left)
	else:
		moving_from_left_to_right = false
		set_pos(start_from_right)

func _fixed_process(delta):
	var motion = Vector2()
	if moving_from_left_to_right:
		motion += Vector2(1, 0)
		if get_pos().x > screen_size.x + sprite_size.x:
			set_initial_position()
	else:
		motion += Vector2(-1, 0)
		if get_pos().x < -sprite_size.x:
			set_initial_position()
		
	motion = motion.normalized() * speed * delta
	move(motion)