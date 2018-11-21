extends Node

var shape_scene = preload("res://scenes/Shape.tscn")

func _ready():
	var shape = shape_scene.instance()
	shape.construct("l")
	shape.set_name("FallingBlock")
	add_child(shape)
	#var new_block = t_shape.instance()
	#new_block.position = Vector2(4 * globals.block_size, 1 * globals.block_size)
	#new_block.set_name("CurrentBlock")
	#add_child(new_block)