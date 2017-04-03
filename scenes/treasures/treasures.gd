extends Node2D

var TREASUE_SPRITE_SIZE = 64
var MIN_DISTANCE_BETWEEN_TREASURES = 128

func _ready():
	randomize_treasures_postion(Utils.shuffle_array([get_node("Chest"), get_node("Grail"), get_node("Gold")]))
	
func randomize_treasures_postion(treasures):
	var number_of_treasures = treasures.size()
	var screen_size = get_viewport_rect().size
	# split a screen into areas where we will add each treasure
	var area_size = (screen_size.x - MIN_DISTANCE_BETWEEN_TREASURES) / number_of_treasures
	
	var area = 1
	var start_range = TREASUE_SPRITE_SIZE
	var end_range = area_size
	
	for node in treasures:
		if(area > 1):
			start_range =  (area_size + TREASUE_SPRITE_SIZE) * (area - 1)
			end_range = area_size * area
		
		randomize()
		var random_number = int(rand_range(start_range, end_range))
		node.set_pos(Vector2(random_number, node.get_pos().y))
		area += 1