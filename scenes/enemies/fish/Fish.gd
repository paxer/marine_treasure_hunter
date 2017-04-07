extends KinematicBody2D

export var speed = 400

onready var screen_size = get_viewport_rect().size
var motion = Vector2()

func _ready():
	set_initial_position()
	set_fixed_process(true)

func set_initial_position():
	randomize()
	var inital_y_position = int(rand_range(128, screen_size.y - 128))
	set_pos(Vector2(0, inital_y_position))

func _fixed_process(delta):
	motion += Vector2(1, 0)
	motion = motion.normalized() * speed * delta
	move(motion)
	
	if(get_pos().x > screen_size.x + get_node("Sprite").get_texture().get_size().x):
		set_initial_position()