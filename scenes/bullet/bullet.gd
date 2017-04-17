extends KinematicBody2D

var speed = 200

onready var player = get_parent()

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var motion = Vector2()
	motion += Vector2(-1, 0)
	motion = motion.normalized() * speed * delta
	move(motion)

	if get_global_pos().x < -32 or get_global_pos().x > Global.screen_size.x:
		self.queue_free()