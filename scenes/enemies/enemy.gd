extends KinematicBody2D 

onready var sprite_size = get_node("Sprite").get_texture().get_size()
onready var timer = get_node("Timer")

var speed
var motion = Vector2()
enum directions {left, right}
var current_directon
var timeout = true
var inital_y_position = 0
var start_from_left = Vector2()
var start_from_right = Vector2()

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
	
func _fixed_process(delta):
	if(is_colliding()):
		get_collider().killed() # it is always a Player
	
	if !timeout:
		move_enemy(delta)


func set_initial_position():
	motion = Vector2()
	randomize()
	# an enemy can start moving from the left or right sides of the screen
	start_from_left = Vector2(-sprite_size.x, inital_y_position)
	start_from_right = Vector2(Global.screen_size.x + sprite_size.x, inital_y_position)
	
	# 50% chance to move from right or left
	if randf() > 0.5:
		current_directon = directions.right
		set_pos(start_from_left)
	else:
		current_directon = directions.left
		set_pos(start_from_right)

func move_enemy(delta):
	if current_directon == directions.right:
		motion += Vector2(1, 0)
		if get_pos().x > Global.screen_size.x + sprite_size.x:
			set_initial_position_after_timeout()
			
	if current_directon == directions.left:
		motion += Vector2(-1, 0)
		if get_pos().x < -sprite_size.x:
			set_initial_position_after_timeout()
		
	motion = motion.normalized() * speed * delta
	move(motion)