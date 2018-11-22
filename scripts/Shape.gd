extends Node2D

var pos = Vector2(4, 2)

var formation
var rot = 0

var rots = {
	"i": {
		0: [Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0)],
		90: [Vector2(2, 0), Vector2(2, 1), Vector2(2, 2), Vector2(2, 3)],
		180: [Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(3, 1)],
		270: [Vector2(1, 0), Vector2(1, 1), Vector2(1, 2), Vector2(1, 3)]
	},
	"z": {
		0: [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2, 1)],
		90: [Vector2(2, 0), Vector2(1, 1), Vector2(2, 1), Vector2(1, 2)],
		180: [Vector2(0, 1), Vector2(1, 1), Vector2(1, 2), Vector2(2, 2)],
		270: [Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(0, 2)]
	},
	"t": {
		0: [Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)],
		90: [Vector2(1, 0), Vector2(1, 2), Vector2(1, 1), Vector2(2, 1)],
		180: [Vector2(1, 2), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)],
		270: [Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, 2)]
	},
	"o": {
		0: [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)],
		90: [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)],
		180: [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)],
		270: [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)]
	},
	"l": {
		0: [Vector2(0, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)],
		90: [Vector2(1, 0), Vector2(2, 0), Vector2(1, 1), Vector2(1, 2)],
		180: [Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(2, 2)],
		270: [Vector2(1, 0), Vector2(1, 1), Vector2(1, 2), Vector2(0, 2)]
	}
}

var block_scene = preload("res://scenes/Block.tscn")
var texture_path = "res://assets/"

func construct(type):
	formation = type
	
	if type == "i":
		add_shape("cyan_block", rots["i"][0])
	elif type == "z":
		add_shape("pink_block", rots["z"][0])
	elif type == "t":
		add_shape("purple_block", rots["t"][0])
	elif type == "o":
		add_shape("red_block", rots["o"][0])
		pos.x += 1
	elif type == "l":
		add_shape("yellow_block", rots["l"][0])
	
	update_position()

func update_position():
	position = Vector2(pos.x * 50, pos.y * 50)

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
	
	if !fall_collision():
		update_position()
		return true
	
	pos.y -= 1
	solidify()
	
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
		if move_collision():
			pos.x += 1
		else:
			update_position()
	elif Input.is_action_just_pressed("move_right"):
		pos.x += 1
		if move_collision():
			pos.x -= 1
		else:
			update_position()
	elif Input.is_action_just_pressed("move_down"):
		if fall():
			$FallTimer.start()
	elif Input.is_action_just_pressed("drop"):
		drop()
	elif Input.is_action_just_pressed("rotate_left"):
		rotate(-90)
		if any_collision():
			rotate(90)
	elif Input.is_action_just_pressed("rotate_right"):
		rotate(90)
		if any_collision():
			rotate(-90)

func rotate(degrees):
	rot += degrees
	if rot < 0:
		rot += 360
	else:
		rot %= 360
	
	var i = 0
	while i < 4:
		$Blocks.get_child(i).pos = rots[formation][rot][i]
		$Blocks.get_child(i).update_position()
		
		i += 1

func drop():
	while fall():
		pass

func ground_collision(block):
	return pos.y + block.pos.y == 21

func wall_collision(block):
	return pos.x + block.pos.x == 0 || pos.x + block.pos.x == 11

func solid_blocks_collision(own_block):
	var solid_blocks = get_parent().get_node("SolidBlocks")
	
	for other_block in solid_blocks.get_children():
		if pos.y + own_block.pos.y == other_block.pos.y && pos.x + own_block.pos.x == other_block.pos.x:
			return true
	return false

func fall_collision():
	for own_block in $Blocks.get_children():
		if ground_collision(own_block):
			return true
		else:
			if solid_blocks_collision(own_block):
				return true
	return false

func move_collision():
	for own_block in $Blocks.get_children():
		if wall_collision(own_block):
			return true
		else:
			if solid_blocks_collision(own_block):
				return true
	return false

func any_collision():
	for own_block in $Blocks.get_children():
		if ground_collision(own_block) || wall_collision(own_block):
			return true
		else:
			if solid_blocks_collision(own_block):
				return true
	return false