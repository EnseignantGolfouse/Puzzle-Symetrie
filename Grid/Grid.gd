extends Node
class_name Grid


export(float) var tile_size: float = 80
export(PackedScene) var Tile


func _ready():
	while self.get_child_count() != 0:
		self.remove_child(self.get_child(0))
	for _i in range(0, self.columns):
		for _j in range(0, self.columns):
			var new_tile = Tile.instance()
			new_tile.rect_size = Vector2(self.tile_size, self.tile_size)
			new_tile.rect_min_size = Vector2(self.tile_size, self.tile_size)
			new_tile.show()
			self.add_child(new_tile)
	self.rect_size = Vector2(
		self.tile_size * self.columns, self.tile_size * self.columns
	)
