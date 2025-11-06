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
var pointTotals:Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]

@onready var potMenu = %PotMenu

signal itemSent(item)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var interactNode = get_node("Interactable") # connect to child interactable component
	if interactNode:
		interactNode.interacted.connect(_on_interacted)
	GlobalInventory.itemSent.connect(itemSent.emit)
	itemSent.connect(_on_itemSent)
	pointTotals.resize(9)

func _on_interacted():
	Globals.changeUI("pot")
	potMenu.visible = !potMenu.visible

func addIngredient(item):
	if item["type"].contains("Ingredient"):
		print(item["name"], "'s point totals: ", item["pointTotals"])
		for i in range(item["pointTotals"].size()):
			pointTotals[i] += item["pointTotals"][i]
		print("Cauldron point totals: ", pointTotals)
	else:
		push_error("!ERROR! Noningredient attempted to add to pot!")

func _on_itemSent(item):
	addIngredient(item)
	GlobalInventory.removeItem(item["name"], item["type"])
