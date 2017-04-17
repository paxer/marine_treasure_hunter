extends KinematicBody2D

var speed = 400
var motion = Vector2()
var current_direction

onready var game = get_tree().get_root().get_node("game")
onready var player = get_tree().get_root().get_node("game").get_node("Player")
onready var sprite_texture_size = get_node("Sprite").get_texture().get_size()
onready var player_initial_position = player.get_pos()

func init(direction):
	current_direction = direction

func _ready():
	set_pos(Vector2(player_initial_position.x, player_initial_position.y -32)) # TODO: adjust the position after the player sprite complete
	set_fixed_process(true)
	
func _fixed_process(delta):
	if(current_direction == player.directions.left):
		motion += Vector2(-1, 0)
		
	if(current_direction == player.directions.right):
		motion += Vector2(1, 0)
		
	motion = motion.normalized() * speed * delta
	move(motion)
	
	if(is_colliding()):
		var collider = get_collider()
		if "enemies" in collider.get_groups():
			killed(collider)
	
	if get_global_pos().x < -sprite_texture_size.x or get_global_pos().x > Global.screen_size.x + sprite_texture_size.x:
		queue_free()
		
func killed(collider):
	# TODO: play killed animation
	# TODO: + game score
	# TODO: detect the collider type and instantiate the same?
	collider.queue_free()
	game.instantiate_fish()
	