extends Node

var shape_scene = preload("res://scenes/Shape.tscn")

var shapes = ["l", "t", "o", "z", "i"]

func _ready():
	randomize()
	spawn_shape()

func spawn_shape():
	var shape = shape_scene.instance()
	shape.construct(shapes[randi()%shapes.size()])
	shape.set_name("FallingBlock")
	shape.get_node("FallTimer").wait_time = $SpawnTimer.wait_time
	add_child(shape)
	
	# Check if spawning the shape caused collision
	if shape.any_collision():
		remove_child(shape)
		shape.queue_free()
		get_node("UI/GameOverLabel").visible = true

func check_full_line():
	var lines = []
	for i in range(20):
		lines.append([])
	
	# Per line, remember which blocks are on it.
	for block in $SolidBlocks.get_children():
		lines[block.pos.y - 1].append(block)
	
	# Check every line for a full line.
	var line_index = 0
	while line_index < lines.size():
		if lines[line_index].size() == 10:
			# Found a full line.
			# Remove every block on this line.
			for block in lines[line_index]:
				$SolidBlocks.remove_child(block)
				block.queue_free()
			
			# Move all lines above it one down.
			var move_line_index = line_index - 1
			while move_line_index >= 0:
				for block in lines[move_line_index]:
					block.pos.y += 1
					block.update_position()
				
				move_line_index -= 1
			
			get_node("UI/ScoreCounter").text = str(int(get_node("UI/ScoreCounter").text) + 1)
			$SpawnTimer.wait_time *= 0.9
		line_index += 1