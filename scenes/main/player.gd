extends KinematicBody2D

signal killed()

var speed = 200
var screen_size
var player_size
var half_of_player_size_y
var half_of_player_size_x
var treasure
var killed = false
onready var camera_anim = get_parent().find_node("CameraAnimation")
onready var timer = get_node("Timer")

var shake_amount = 1.0

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
			treasure.queue_free()
			treasure = null
			
		if "enemies" in collider.get_groups():
			killed()
			
	if(treasure):
		treasure.set_pos(Vector2(get_pos().x + 20, get_pos().y + 30))
		
func killed():
	if(!killed):
		Global.lives -= 1
		killed = true
		camera_anim.play("shake")
		killed = false
		get_tree().set_pause(true)
		timer.start()
		yield(timer, "timeout") 
		get_tree().reload_current_scene()
		get_tree().set_pause(false)
		emit_signal("killed")