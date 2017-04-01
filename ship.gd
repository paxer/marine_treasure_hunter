extends KinematicBody2D

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var player_position = get_parent().get_node("Player").get_pos()
	set_pos(Vector2(player_position.x, get_pos().y))