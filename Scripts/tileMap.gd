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
const emptyPotAtlasPos = Vector2i(3,0)
const fullPotAtlasPos = Vector2i(4,0)
const purpleBlockAtlasPos = Vector2i(5,0)
const orangeBlockAtlasPos = Vector2i(6,0)
const boundaryAtlasPos = Vector2i(7,0)
const wallAtlasPos = Vector2i(0,1)
const floorAtlasPos = Vector2i(1,1)
const doorTopAtlasPos = Vector2i(2,1)
const doorBottomAtlasPos = Vector2i(3,1)
const windowBottomAtlasPos = Vector2i(4,1)
const windowTopAtlasPos = Vector2i(5,1)
const cauldronAtlasPos = Vector2i(6,1)
const sofa1AtalasPos = Vector2i(0,2)
const sofa2tAtlasPos = Vector2i(1,2)
const woodblock = Vector2i(2,2)
const table_left = Vector2i(3,2)
const table_right = Vector2i(4,2)
const table_down = Vector2i(5,2)
const table_up = Vector2i(6,2)


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
