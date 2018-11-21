extends Polygon2D

var pos

func construct(pos_):
	pos = pos_
	update_position()

func update_position():
	position = Vector2(pos.x * 50, pos.y * 50)