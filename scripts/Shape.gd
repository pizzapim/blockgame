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

func fall():
	pos.y += 1
	
	if check_fall_collision():
		update_position()
		return true
	
	pos.y -= 1
	solidify()
	
	get_parent().get_node("SpawnTimer").wait_time = $FallTimer.wait_time
	get_parent().get_node("SpawnTimer").start()
	get_parent().check_full_line()
	
	queue_free()
	
	return false

func solidify():
	var solid_blocks = get_parent().get_node("SolidBlocks")
	
	for block in $Blocks.get_children():
		$Blocks.remove_child(block)
		block.pos += pos
		block.update_position()
		solid_blocks.add_child(block)

func _input(ev):
	if Input.is_action_just_pressed("move_left"):
		pos.x -= 1
		if check_move_collision():
			update_position()
		else:
			pos.x += 1
	elif Input.is_action_just_pressed("move_right"):
		pos.x += 1
		if check_move_collision():
			update_position()
		else:
			pos.x -= 1
	elif Input.is_action_just_pressed("move_down"):
		if fall():
			$FallTimer.start()
	elif Input.is_action_just_pressed("drop"):
		drop()
func drop():
	while fall():
		pass

func check_fall_collision():
	var solid_blocks = get_parent().get_node("SolidBlocks")
	
	for own_block in $Blocks.get_children():
		if pos.y + own_block.pos.y == 21:
			return false
		else:
			for other_block in solid_blocks.get_children():
				if pos.y + own_block.pos.y == other_block.pos.y && pos.x + own_block.pos.x == other_block.pos.x:
					return false
	return true

func check_move_collision():
	var solid_blocks = get_parent().get_node("SolidBlocks")
	
	for own_block in $Blocks.get_children():
		if pos.x + own_block.pos.x == 0 || pos.x + own_block.pos.x == 11:
			return false
		else:
			for other_block in solid_blocks.get_children():
				if pos.y + own_block.pos.y == other_block.pos.y && pos.x + own_block.pos.x == other_block.pos.x:
					return false
	return true