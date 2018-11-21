extends Node

var shape_scene = preload("res://scenes/Shape.tscn")

func _ready():
	spawn_shape()

func spawn_shape():
	var shape = shape_scene.instance()
	shape.construct("l")
	shape.set_name("FallingBlock")
	add_child(shape)