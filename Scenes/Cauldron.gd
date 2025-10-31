extends Node2D

enum Element {
	FIRE,
	WATER,
	EARTH,
	AIR,
	LIGHT,
	DARK,
	MIND,
	BODY,
	SPIRIT
}
var pointTotals = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var childNode = get_node("Interactable") # connect to child interactable component
	if childNode:
		childNode.interacted.connect(_on_interacted)
	
	pointTotals.resize(9)

func _on_interacted():
	print("Interacted!")

func addIngredient(item):
	if item["type"] == "Ingredient" or item["type"] == "Prepared Ingredient":
		print(item["pointTotals"])
		for i in range(item["pointTotals"]):
			pointTotals[i] += item["pointTotals"]
		print(pointTotals)
	else:
		push_error("!ERROR! Noningredient attempted to add to pot!")
