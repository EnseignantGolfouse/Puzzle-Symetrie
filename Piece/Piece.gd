tool
extends Polygon2D

export(Color) var OutLine = Color(0,0,0) setget set_color
export(float) var Width = 2.0 setget set_width

func _draw():
	var poly = get_polygon()
	for i in range(1 , poly.size()):
		draw_line(poly[i-1] , poly[i], OutLine , Width)
	draw_line(poly[poly.size() - 1] , poly[0], OutLine , Width)

func set_color(color):
	OutLine = color
	update()

func set_width(new_width):
	Width = new_width
	update()

# Returns `true` if `point` is inside the polygon.
func is_point_inside(point: Vector2) -> bool:
	# ray-casting algorithm based on
	# https://wrf.ecse.rpi.edu/Research/Short_Notes/pnpoly.html/pnpoly.html
	var x: float = point.x
	var y: float = point.y
	var polygon = self.polygon
	var inside: bool = false;
	var j = polygon.size() - 1
	var i = 0
	while true:
		if i >= polygon.size():
			break
		var xi = polygon[i].x
		var yi = polygon[i].y
		var xj = polygon[j].x
		var yj = polygon[j].y
		var intersect: bool = (
			((yi > y) != (yj > y)) and
			(x < (xj - xi) * (y - yi) / (yj - yi) + xi)
		)
		if intersect:
			inside = not inside
		j = i
		i += 1
	return inside;

# Rotate the polygon 90 degrees clockwise around `center`.
func rotate_around(center: Vector2):
	var new_polygon = []
	for point in self.polygon:
		var center_to_point: Vector2 = point - center
		# rotate by 90 degrees clockwise
		center_to_point = Vector2(-center_to_point.y, center_to_point.x)
		new_polygon.push_back(center + center_to_point)
	self.polygon = new_polygon
	var min_x: float = 0
	var min_y: float = 0
	if self.polygon.size() > 0:
		min_x = self.polygon[0].x
		min_y = self.polygon[0].y
	for point in self.polygon:
		if point.x < min_x:
			min_x = point.x
		if point.y < min_y:
			min_y = point.y
	# align on (0,0)
	for index in range(0, self.polygon.size()):
		self.polygon[index].x -= min_x
		self.polygon[index].y -= min_y

# Mirror the polygon on the x axis.
func mirror_x():
	var max_x: float = 0
	for point in self.polygon:
		if point.x > max_x:
			max_x = point.x
	for index in range(0, self.polygon.size()):
		self.polygon[index].x = max_x - self.polygon[index].x

func find_upper_left_corner() -> Vector2:
	var min_x: float = 0
	var min_y: float = 0
	if self.polygon.size() > 0:
		min_x = self.polygon[0].x
		min_y = self.polygon[0].y
	for point in self.polygon:
		if point.x < min_x:
			min_x = point.x
		if point.y < min_y:
			min_y = point.y
	return Vector2(min_x, min_y)
