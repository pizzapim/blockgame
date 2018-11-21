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
	add_child(shape)