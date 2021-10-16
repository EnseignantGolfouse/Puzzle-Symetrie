extends AspectRatioContainer


var color: Color

func _init(color: Color = Color.white):
	self.color = color

func _ready():
	$Color.color = self.color

func print_node() -> void:
	print("Tile:")
	print("    size = ", self.rect_size)
	print("    position = ", self.rect_position)
	print("    color = ", self.color)
	print("    border_color = ", $Border.border_color)
	print("    border_width = ", $Border.border_width)
