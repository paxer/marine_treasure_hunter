extends KinematicBody2D

export var speed = 200

var screen_size
var player_size
var half_of_player_size_y
var half_of_player_size_x
var treasure

func _ready():
	screen_size = get_viewport_rect().size
	player_size = get_node("Diver").get_texture().get_size()
	half_of_player_size_y = player_size.y / 2
	half_of_player_size_x = player_size.x / 2
	set_fixed_process(true)

func _fixed_process(delta):
	var player_position = get_pos()
	var motion = Vector2()
	
	if (player_position.y > half_of_player_size_y and Input.is_action_pressed("ui_up")):
		motion += Vector2(0, -1)
	
	if (player_position.y < (screen_size.y - half_of_player_size_y) and Input.is_action_pressed("ui_down")):
		motion += Vector2(0, 1)
		
	if (player_position.x > half_of_player_size_x and Input.is_action_pressed("ui_left")):
		motion += Vector2(-1, 0)
		
	if (player_position.x < (screen_size.x - half_of_player_size_x) and Input.is_action_pressed("ui_right")):
		motion += Vector2(1, 0)
		
	motion = motion.normalized()* speed *delta
	move(motion)
	
	if(is_colliding()):
		var collider = get_collider()
		
		if("treasures" in collider.get_groups() and not treasure):
			collider.find_node("CollisionShape2D").set_trigger(true)
			treasure = collider
			
		if("ship" in collider.get_groups() and treasure):
			#remove_child(treasure)
			#var wr = weakref(treasure)
			#if (wr.get_ref()):
			#	print("FREEE")
		    #	treasure.queue_free()
			print("TODO + 1 Score")
			
	if(treasure):
		treasure.set_pos(Vector2(get_pos().x + 20, get_pos().y + 30))