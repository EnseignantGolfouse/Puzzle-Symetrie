extends Control

signal button_pressed

var id: int

func init(color: Color, points: Array, id: int):
	self.id = id
	$Piece.color = color
	var max_x: float = 0
	var min_x: float = 0
	var max_y: float = 0
	var min_y: float = 0
	if points.size() > 0:
		max_x = points[0].x
		min_x = points[0].x
		max_y = points[0].y
		min_y = points[0].y
	for point in points:
		if point.x > max_x:
			max_x = point.x
		if point.x < min_x:
			min_x = point.x
		if point.y > max_y:
			max_y = point.y
		if point.y < min_y:
			min_y = point.y
	$Piece.position = Vector2(10, 10)
	self.rect_size.x = (max_x - min_x) + 20
	self.rect_min_size.x = (max_x - min_x) + 20
	self.rect_size.y = (max_y - min_y) + 20
	self.rect_min_size.y = (max_y - min_y) + 20
	var new_points = []
	for point in points:
		point.x -= min_x
		point.y -= min_y
		new_points.push_back(point)
	$Piece.polygon = new_points

func get_piece():
	return $Piece.duplicate()

func _on_PieceMenu_pressed():
	self.emit_signal("button_pressed", $Piece, self.id)
