extends Node2D

var pos = Vector2(4, 2)

var block_scene = preload("res://scenes/Block.tscn")
var texture_path = "res://assets/"

func construct(type):
	if type == "i":
		add_i_shape()
	elif type == "z":
		add_z_shape()
	elif type == "t":
		add_t_shape()
	elif type == "o":
		add_o_shape()
		pos.x += 1
	elif type == "l":
		add_l_shape()
	
	update_position()

func update_position():
	position = Vector2(pos.x * 50, pos.y * 50)

func add_i_shape():
	add_shape("cyan_block", [
		Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0)
	])

func add_z_shape():
	add_shape("pink_block", [
		Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2, 1)
	])

func add_t_shape():
	add_shape("purple_block", [
		Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)
	])

func add_o_shape():
	add_shape("red_block", [
		Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)
	])

func add_l_shape():
	add_shape("yellow_block", [
		Vector2(0, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)
	])

func add_shape(texture_name, positions):
	var texture = load(texture_path + texture_name + ".png")
	for position in positions:
		add_block(position, texture)

func add_block(pos_, texture):
	var block = block_scene.instance()
	block.construct(pos_)
	block.texture = texture
	$Blocks.add_child(block)