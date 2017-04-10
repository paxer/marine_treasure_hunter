extends Node2D

var screen_size
onready var player = get_node("Player")

func _ready():
	screen_size = get_viewport_rect().size
	draw_environment("res://scenes/seabed/seabed.tscn")
	draw_environment("res://scenes/sky/sky.tscn")
	draw_treasures()
	instantiate_enemies()
	draw_stats()
	player.connect("killed", self, "draw_stats")
	
#  this is the initial version and most-likely wil be refactored once I'll get a better understanding how it all works
func draw_environment(scene_path):
	# first of all we need to calculate how many grass blocks we need to add to the screen	
	# we have 1 inital grass block on the Seabed.tscn scene
	var initial_grass_block = load(scene_path).instance()
	add_child(initial_grass_block)
	var initial_grass_block_size = initial_grass_block.get_node("Sprite").get_texture().get_size()
	var number_of_grass_blocks_to_add = (screen_size.x / initial_grass_block_size.x) - 1 # since again, we already have one
	
	# now add all additional grass blocks to the screen
	var last_added_grass_x_coordinate = initial_grass_block.get_pos().x
	
	for i in range(number_of_grass_blocks_to_add):
		last_added_grass_x_coordinate += initial_grass_block_size.x
		var new_grass_block = load(scene_path).instance()
		new_grass_block.set_pos(Vector2(last_added_grass_x_coordinate, new_grass_block.get_pos().y))
		add_child(new_grass_block)

func draw_treasures():
	var treasures = load("res://scenes/treasures/treasures.tscn").instance()
	add_child(treasures)
	
func instantiate_enemies():
	var fish = load("res://scenes/enemies/fish/fish.tscn").instance()
	add_child(fish)
	
	var crab = load("res://scenes/enemies/crab/crab.tscn").instance()
	add_child(crab)
	
func draw_stats():
	find_node("Lives").set_text(str("Lives: ", Global.lives))