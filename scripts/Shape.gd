extends Node2D

var pos

var block_scene = preload("res://scenes/Block.tscn")

func construct(type, pos_):
	pos = pos_
	update_position()
	
	if type == "i":
		add_i_shape()
	elif type == "z":
		add_z_shape()
	elif type == "t":
		add_t_shape()
	elif type == "o":
		add_o_shape()
	elif type == "l":
		add_l_shape()

func update_position():
	position = Vector2(pos.x * 50, pos.y * 50)

func add_i_shape():
	var texture = load("res://assets/cyan_block.png")
	add_block(Vector2(0, 0), texture)
	add_block(Vector2(1, 0), texture)
	add_block(Vector2(2, 0), texture)
	add_block(Vector2(3, 0), texture)

func add_z_shape():
	var texture = load("res://assets/pink_block.png")
	add_block(Vector2(0, 0), texture)
	add_block(Vector2(1, 0), texture)
	add_block(Vector2(1, 1), texture)
	add_block(Vector2(2, 1), texture)

func add_t_shape():
	var texture = load("res://assets/purple_block.png")
	add_block(Vector2(1, 0), texture)
	add_block(Vector2(0, 1), texture)
	add_block(Vector2(1, 1), texture)
	add_block(Vector2(2, 1), texture)

func add_o_shape():
	var texture = load("res://assets/red_block.png")
	add_block(Vector2(0, 0), texture)
	add_block(Vector2(1, 0), texture)
	add_block(Vector2(0, 1), texture)
	add_block(Vector2(1, 1), texture)

func add_l_shape():
	var texture = load("res://assets/yellow_block.png")
	add_block(Vector2(0, 0), texture)
	add_block(Vector2(0, 1), texture)
	add_block(Vector2(1, 1), texture)
	add_block(Vector2(2, 1), texture)

func add_block(pos_, texture):
	var block = block_scene.instance()
	block.construct(pos_)
	block.texture = texture
	$Blocks.add_child(block)