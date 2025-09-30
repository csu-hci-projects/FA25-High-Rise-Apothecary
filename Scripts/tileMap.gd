extends TileMap

enum layers {
	level0 = 0,
	level1 = 1,
	level2 = 2
}
const mainSource = 0
const blueBlockAtlasPos = Vector2i(0,0)
const redBlockAtlasPos = Vector2i(1,0)
const greenBlockAtlasPos = Vector2i(2,0)
const whiteBlockAtlasPos = Vector2i(3,0)
const blackBlockAtlasPos = Vector2i(4,0)
const purpleBlockAtlasPos = Vector2i(5,0)
const orangeBlockAtlasPos = Vector2i(6,0)
const boundaryAtlasPos = Vector2i(7,0)

func placeBoundaries():
	var offsets = [
		Vector2i(0,-1),
		Vector2i(0,1),
		Vector2i(-1,0),
		Vector2i(1,0)
	]
	var used = get_used_cells(layers.level0)
	for spot in used:
		for offset in offsets:
			var currentSpot = spot + offset
			if get_cell_source_id(layers.level0, currentSpot) == -1:
				set_cell(layers.level0, currentSpot, mainSource, boundaryAtlasPos)
	
func _ready() -> void:
	placeBoundaries()

func _process(_delta: float) -> void:
	pass
