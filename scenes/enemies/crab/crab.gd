extends "res://scenes/enemies/enemy.gd"

func set_initial_position():
	randomize()
	speed = int(rand_range(50, 100))
	inital_y_position = Global.screen_size.y - 86
	.set_initial_position()