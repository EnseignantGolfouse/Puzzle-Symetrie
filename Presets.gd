extends Button
signal preset_selected

# [name, [position, angle, mirrored, polygon_index]]
# - name is a string.
# - position is a Vector2.
# - angle is in {0, 1, 2, 3}.
# - mirrored is a boolean.
# - polygon_index is the index of the polygon in the `POLYGONS` constant.
# NOTE : mirroring happens **after** application of the angle.
const PRESETS: Array = [
	["Modèle 1", [
		[Vector2(1,2), 0, false, 0],
		[Vector2(2,1), 0, false, 0],
		[Vector2(1,1), 0, false, 1],
		[Vector2(2,2), 2, false, 1],
		[Vector2(1,3), 0, false, 2],
		[Vector2(3,1), 1, true,  2],
		[Vector2(0,0), 0, false, 3],
		[Vector2(0,0), 1, false, 3],
		[Vector2(3,0), 1, true,  4],
		[Vector2(0,3), 0, false, 4],
		[Vector2(3,4), 0, false, 5],
		[Vector2(4,3), 1, true,  5],
		[Vector2(2,4), 1, false, 6],
		[Vector2(4,2), 2, false, 6],
	]],
	["Modèle 2", [
		[Vector2(0,3), 0, false, 0],
		[Vector2(1,4), 0, false, 0],
		[Vector2(1,1), 0, false, 1],
		[Vector2(2,2), 2, false, 1],
		[Vector2(1,3), 0, false, 2],
		[Vector2(3,1), 1, true,  2],
		[Vector2(0,0), 0, false, 3],
		[Vector2(0,0), 1, false, 3],
		[Vector2(3,0), 1, true,  4],
		[Vector2(0,3), 0, false, 4],
		[Vector2(3,4), 0, false, 5],
		[Vector2(4,3), 1, true,  5],
		[Vector2(2,4), 1, false, 6],
		[Vector2(4,2), 2, false, 6],
	]],
	["Modèle 3", [
		
	]],
	["Modèle 4", [
		
	]],
	["Modèle 5", [
		
	]],
	["Modèle 6", [
		[Vector2(2,1), 0, false, 0],
		[Vector2(2,3), 0, false, 0],
		[Vector2(0,4), 2, false, 1],
		[Vector2(4,4), 3, false, 1],
		[Vector2(0,3), 0, true,  2],
		[Vector2(5,3), 0, false, 2],
		[Vector2(0,0), 0, false, 3],
		[Vector2(5,0), 2, false, 3],
		[Vector2(0,0), 2, false, 4],
		[Vector2(4,0), 2, true,  4],
		[Vector2(1,2), 1, false, 5],
		[Vector2(3,2), 1, true,  5],
		[Vector2(2,0), 2, false, 6],
		[Vector2(2,4), 0, false, 6],
	]],
	["Efface", []]
]

func _ready():
	var index = 0
	for preset in PRESETS:
		$PresetsMenu.add_item(preset[0], index)
		index += 1

func _on_Presets_pressed():
	$PresetsMenu.popup_centered()

func _on_PresetsMenu_index_pressed(index: int):
	self.emit_signal("preset_selected", PRESETS[index][1])
