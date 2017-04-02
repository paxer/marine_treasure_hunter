extends Node

static func shuffle_array(array):
	var shuffled_array = []
	var index_array = range(array.size())
	for i in range(array.size()):
		randomize()
		var x = randi()%index_array.size()
		shuffled_array.append(array[x])
		index_array.remove(x)
		array.remove(x)
	return shuffled_array