extends "res://scenes/enemies/enemy.gd"
	
func set_initial_position():
	randomize()
	speed = int(rand_range(150, 200))
	inital_y_position = int(rand_range(160, Global.screen_size.y - 160))
	.set_initial_position()