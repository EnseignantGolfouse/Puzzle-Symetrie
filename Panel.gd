extends Node


export(PackedScene) var Piece
const POLYGONS = [
	# 0: red square
	[Color.red, [Vector2(0, 1), Vector2(1, 2), Vector2(2, 1), Vector2(1, 0)]],
	# 1: red triangle
	[Color.red, [Vector2(0, 0), Vector2(0, 2), Vector2(2, 0)]],
	# 2: red Parallelepiped
	[Color.red, [Vector2(0, 0), Vector2(0, 2), Vector2(1, 3), Vector2(1, 1)]],
	# 3: yellow elongated trapeze
	[Color.yellow, [Vector2(0, 0), Vector2(0, 4), Vector2(1, 3), Vector2(1, 1)]],
	# 4: yellow weird form
	[Color.yellow, [Vector2(0, 1), Vector2(0, 3), Vector2(2, 3), Vector2(1, 2), Vector2(1, 0)]],
	# 5: yellow squared + triangle
	[Color.yellow, [Vector2(0, 1), Vector2(1, 2), Vector2(3, 2), Vector2(1, 0)]],
	# 6: yellow square missing a bit
	[Color.yellow, [Vector2(0, 0), Vector2(0, 2), Vector2(2, 2), Vector2(2, 0), Vector2(1, 1)]],
]
var held_piece = null
var held_piece_offset_x = 0
var held_piece_offset_y = 0
var placed_pieces: Array = []


func _ready():
	var screen_size = get_viewport().size
	$PiecesMenu/DeletePieceCenter/DeletePiece.rect_min_size.y += 2 * $GridCenter/Grid.tile_size
	$PiecesMenu/DeletePieceCenter/DeletePiece.rect_size.x = $PiecesMenu/DeletePieceCenter.rect_size.x
	var button_id = 0
	for polygon in POLYGONS:
		var scaled_polygon = []
		for point in polygon[1]:
			scaled_polygon.push_back(point * $GridCenter/Grid.tile_size)
		var piece = Piece.instance()
		piece.init(polygon[0], scaled_polygon, button_id)
		piece.connect("button_pressed", self, "on_piece_button_pressed")
		$PiecesMenu/Pieces.add_child(piece)
		button_id += 1
	$GridCenter.rect_size.x = screen_size.x / 2
	$GridCenter.rect_min_size.x = screen_size.x / 2

# `polygons` is an array of [position, angle, mirrored, polygon_index]
func load_preset(polygons: Array):
	if self.held_piece != null:
		self.remove_child(self.held_piece)
		self.held_piece = null
	for piece in self.placed_pieces:
		self.remove_child(piece)
	self.placed_pieces = []
	for polygon in polygons:
		var position: Vector2 = polygon[0]
		var angle: int = polygon[1]
		var mirrored: bool = polygon[2]
		var polygon_index: int = polygon[3]
		# the piece is now in `self.held_piece`.
		var piece = $PiecesMenu/Pieces.get_child(polygon_index).get_piece()
		piece.show()
		self.add_child(piece)
		self.hold_piece(piece)
		for _i in range(0, angle):
			self.rotate_held_piece()
		if mirrored:
			self.mirror_held_piece()
		self.held_piece.position = ($GridCenter/Grid.tile_size * position) + $GridCenter/Grid.rect_position
		self.placed_pieces.push_front(self.held_piece)
		self.held_piece = null

# returns an array `[max_x, min_x, max_y, min_y]`.
static func get_dimensions(points: Array) -> Array:
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
	return [max_x, min_x, max_y, min_y]

func hold_piece(piece):
	piece.position = get_viewport().get_mouse_position()
	match get_dimensions(piece.polygon):
		[var max_x, var min_x, var max_y, var min_y]:
			self.held_piece_offset_x = -(max_x + min_x) / 2
			self.held_piece_offset_y = -(max_y + min_y) / 2
			piece.position.x += self.held_piece_offset_x
			piece.position.y += self.held_piece_offset_y
	self.held_piece = piece
	self.held_piece.z_index = self.placed_pieces.size()

func rotate_held_piece():
	var center = Vector2(
		-self.held_piece_offset_x,
		-self.held_piece_offset_y
	)
	self.held_piece.rotate_around(center)
	var temp = self.held_piece_offset_x
	self.held_piece_offset_x = self.held_piece_offset_y
	self.held_piece_offset_y = temp
	self.held_piece.position = get_viewport().get_mouse_position()
	self.held_piece.position.x += self.held_piece_offset_x
	self.held_piece.position.y += self.held_piece_offset_y

func mirror_held_piece():
	self.held_piece.mirror_x()

func on_piece_button_pressed(piece, _piece_id: int):
	var new_piece = piece.duplicate()
	new_piece.show()
	if self.held_piece != null:
		self.remove_child(self.held_piece)
	self.add_child(new_piece)
	self.hold_piece(new_piece)

# Returns `null` if `position` is far away from the grid.
func approximate_placement(position: Vector2):
	var grid_position: Vector2 = $GridCenter/Grid.rect_position
	var grid_size: Vector2 = $GridCenter/Grid.rect_size
	var tile_size: float = $GridCenter/Grid.tile_size
	if (position.x <= grid_position.x - tile_size/2 or
		position.y <= grid_position.y - tile_size/2 or
		position.x >= grid_position.x + grid_size.x - tile_size/2 or
		position.y >= grid_position.y + grid_size.y - tile_size/2):
		return null
	for potential_position in range(
		grid_position.x,
		grid_position.x + grid_size.x,
		tile_size/2
	):
		if abs(position.x - potential_position) <= tile_size/4:
			position.x = potential_position
			break
	for potential_position in range(
		grid_position.y,
		grid_position.y + grid_size.y,
		tile_size/2
	):
		if abs(position.y - potential_position) <= tile_size/4:
			position.y = potential_position
			break
	return position

func _input(event: InputEvent):
	if (event is InputEventMouseMotion):
		if self.held_piece != null:
			self.held_piece.position = event.position
			self.held_piece.position.x += self.held_piece_offset_x
			self.held_piece.position.y += self.held_piece_offset_y
	if (event is InputEventMouseButton and event.is_pressed()):
		if self.held_piece != null:
			var position: Vector2 = self.held_piece.position
			match self.approximate_placement(position):
				null: pass
				var approx_position:
					self.held_piece.position = approx_position
					self.placed_pieces.push_front(self.held_piece)
					self.held_piece = null
		else:
			var placed_piece_index = 0
			for piece in self.placed_pieces:
				var relative_cursor_position: Vector2 = event.position - piece.position
				if piece.is_point_inside(relative_cursor_position):
					self.placed_pieces.remove(placed_piece_index)
					self.hold_piece(piece)
					break
				placed_piece_index += 1
			for index in range(0, self.placed_pieces.size()):
				self.placed_pieces[index].z_index = self.placed_pieces.size() - 1 - index
	if (event is InputEventKey):
		if (event.scancode == KEY_R and event.is_pressed()):
			if self.held_piece != null: self.rotate_held_piece()
		if (event.scancode == KEY_S and event.is_pressed()):
			if self.held_piece != null: self.mirror_held_piece()

func _on_DeletePiece_pressed():
	if self.held_piece != null:
		self.remove_child(self.held_piece)
		self.held_piece = null

func _on_Presets_preset_selected(polygons):
	self.load_preset(polygons)
