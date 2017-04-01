extends KinematicBody2D

var player_position

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	player_position = get_parent().get_node("Player").get_pos()
	set_pos(Vector2(player_position.x, get_pos().y))
	update()
	
func _draw():
	draw_hose()

func draw_hose():
	var distance_between_ship_and_player = Vector2(player_position - get_pos() )
	var number_of_segments = int((distance_between_ship_and_player.y - get_node("Sprite").get_texture().get_size().y) / 10)
	
	var segment_step = 10
	var start_segment_y = 35
	var end_segment_y = 40
	
	for i in range(number_of_segments):
		draw_line(Vector2(0, start_segment_y), Vector2(0, end_segment_y), Color(255, 255, 0), 3)
		start_segment_y += segment_step
		end_segment_y += segment_step