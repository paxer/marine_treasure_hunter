extends KinematicBody2D

var speed = 400
var motion = Vector2()
var current_direction

onready var player = get_tree().get_root().get_node("game").get_node("Player")
onready var sprite_texture_size = get_node("Sprite").get_texture().get_size()
onready var player_initial_position = player.get_pos()

func init(direction):
	current_direction = direction

func _ready():
	set_pos(player_initial_position)
	set_fixed_process(true)
	
func _fixed_process(delta):
	if(current_direction == player.directions.left):
		motion += Vector2(-1, 0)
		
	if(current_direction == player.directions.right):
		motion += Vector2(1, 0)
		
	motion = motion.normalized() * speed * delta
	move(motion)
	
	if get_global_pos().x < -sprite_texture_size.x or get_global_pos().x > Global.screen_size.x + sprite_texture_size.x:
		self.queue_free()