extends KinematicBody2D
# TODO: at this stage a lot of common behaviour with a crab, maybe use inheritance or composition to encapsulate a common logic?
onready var sprite_size = get_node("Sprite").get_texture().get_size()
onready var timer = get_node("Timer")

var speed
var motion = Vector2()
var timeout = true
enum directions {left, right}
var current_directon

func _ready():
	set_initial_position_after_timeout()
	set_fixed_process(true)

func set_initial_position_after_timeout():
	timeout = true
	set_initial_position()
	timer.connect("timeout", self, "its_show_time")
	randomize()
	timer.set_wait_time(int(rand_range(1, 3)))
	timer.start()
	
func its_show_time():
	timeout = false

func set_initial_position():
	randomize()
	var inital_y_position = int(rand_range(160, Global.screen_size.y - 160))
	speed = int(rand_range(150, 300))
	# a fish can start moving from the left or right sides of the screen bottom
	var start_from_left = Vector2(-sprite_size.x, inital_y_position)
	var start_from_right = Vector2(Global.screen_size.x + sprite_size.x, inital_y_position)
	# 50% chance to move from right or left
	if randf() > 0.5:
		current_directon = directions.right
		set_pos(start_from_left)
	else:
		current_directon = directions.left
		set_pos(start_from_right)

func _fixed_process(delta):
	if !timeout:
		move_fish(delta)
	
func move_fish(delta):
	if current_directon == directions.right:
		motion += Vector2(1, 0)
		if(get_pos().x > Global.screen_size.x + sprite_size.x):
			set_initial_position_after_timeout()
	
	if current_directon == directions.left:
		motion += Vector2(-1, 0)
		if(get_pos().x < -sprite_size.x):
			set_initial_position_after_timeout()
	
	motion = motion.normalized() * speed * delta
	move(motion)