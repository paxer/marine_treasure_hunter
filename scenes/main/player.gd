extends KinematicBody2D

signal killed()

var speed = 200
var player_size
var half_of_player_size_y
var half_of_player_size_x
var treasure
var killed = false
enum directions {left, right}
var current_direction = directions.left
var can_shoot = true
var currently_holding_init_treasure_posistion

onready var camera_anim = get_parent().find_node("CameraAnimation")
onready var reload_scene_timer = get_node("ReloadSceneTimer")
onready var fire_bullet_timer = get_node("BulletFireTimer")

func _ready():
	player_size = get_node("Diver").get_texture().get_size()
	half_of_player_size_y = player_size.y / 2
	half_of_player_size_x = player_size.x / 2
	set_fixed_process(true)

func _fixed_process(delta):
	var player_position = get_pos()
	var motion = Vector2()
	
	if Input.is_action_pressed("ui_select"):
		fire()
	
	if (player_position.y > half_of_player_size_y and Input.is_action_pressed("ui_up")):
		motion += Vector2(0, -1)
	
	if (player_position.y < (Global.screen_size.y - half_of_player_size_y) and Input.is_action_pressed("ui_down")):
		motion += Vector2(0, 1)
		
	if (player_position.x > half_of_player_size_x and Input.is_action_pressed("ui_left")):
		set_direction(directions.left)
		motion += Vector2(-1, 0)
		
	if (player_position.x < (Global.screen_size.x - half_of_player_size_x) and Input.is_action_pressed("ui_right")):
		set_direction(directions.right)
		motion += Vector2(1, 0)
		
	motion = motion.normalized()* speed *delta
	move(motion)
	
	if(is_colliding()):
		var collider = get_collider()
		if("treasures" in collider.get_groups() and not treasure):
			collider.find_node("CollisionShape2D").set_trigger(true)
			treasure = collider
			currently_holding_init_treasure_posistion = treasure.get_pos()
			
		if("ship" in collider.get_groups() and treasure):
			treasure.queue_free()
			treasure = null
			
	if(treasure):
		treasure.set_pos(Vector2(get_pos().x + 20, get_pos().y + 30))
		
func killed():
	if(!killed):
		Global.lives -= 1
		killed = true
		camera_anim.play("shake")
		killed = false
		get_tree().set_pause(true)
		reload_scene_timer.start()
		yield(reload_scene_timer, "timeout") 
		get_tree().set_pause(false)
		set_treasure_pos_after_kill()
		emit_signal("killed")
		

func fire():
	if can_shoot:
		var bullet = load("res://scenes/bullet/bullet.tscn").instance()
		bullet.init(current_direction)
		get_parent().add_child(bullet)
		can_shoot = false
		fire_bullet_timer.connect("timeout", self, "can_shoot_timeout") 
		fire_bullet_timer.start()

func can_shoot_timeout():
	can_shoot = true

func set_direction(direction):
	if direction == directions.left and current_direction == directions.right:
	  get_node("Diver").set_flip_h(false)
	  current_direction = directions.left
	
	if direction == directions.right and current_direction == directions.left:
	  get_node("Diver").set_flip_h(true)
	  current_direction = directions.right

func set_treasure_pos_after_kill():
	if treasure:
		treasure.set_pos(currently_holding_init_treasure_posistion)
		treasure.find_node("CollisionShape2D").set_trigger(false)
		treasure = null