extends Sprite

const SPEED = 200

var screen_size
var player_size
var half_of_player_size_y
var half_of_player_size_x

func _ready():
	screen_size = get_viewport_rect().size
	player_size = self.get_texture().get_size()
	half_of_player_size_y = player_size.y / 2
	half_of_player_size_x = player_size.x / 2
	set_process(true)
	
func _process(delta):
	setup_controller(delta)
	
func setup_controller(delta):
	var player_position = get_pos()
	# do not allow a player to leave the screen
	if (player_position.y > half_of_player_size_y and Input.is_action_pressed("ui_up")):
		player_position.y += -SPEED * delta
		
	if (player_position.y < (screen_size.y - half_of_player_size_y) and Input.is_action_pressed("ui_down")):
		player_position.y -= -SPEED * delta
		
	if (player_position.x > half_of_player_size_x and Input.is_action_pressed("ui_left")):
		player_position.x += -SPEED * delta
	
	if (player_position.x < (screen_size.x - half_of_player_size_x) and Input.is_action_pressed("ui_right")):
		player_position.x -= -SPEED * delta
	
	self.set_pos(player_position)