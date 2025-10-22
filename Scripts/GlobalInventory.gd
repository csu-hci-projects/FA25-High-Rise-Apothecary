extends Node

var inventory = []

signal inventoryUpdated

var playerNode: Node = null

@onready var inventorySlotScene = preload("res://Scenes/inventorySlot.tscn")

func _ready() -> void:
	inventory.resize(8)

func setPlayerNode(player):
	playerNode = player

func addItem(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["type"] == item["type"]: # if this item is already in the inventory
			inventory[i]["quantity"] += item["quantity"]
			inventoryUpdated.emit()
			print("Inventory item added to existing slot")
			return true
		elif inventory[i] == null: # if there is an empty slot
			inventory[i] = item
			inventoryUpdated.emit()
			print("Inventory item added to new slot")
			return true
	changeInvSize(8)
	print("No inventory space, increasing size")
	if !addItem(item):
		print("Cannot add to inventory")
		return false

func removeItem(itemName, itemType):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == itemName and inventory[i]["type"] == itemType:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventoryUpdated.emit()
			return true
	return false

func changeInvSize(slots):
	inventory.resize(inventory.size() + slots)
	inventoryUpdated.emit()

func sortByType(a: Dictionary, b: Dictionary):
	return a["type"] < b["type"]

func sortInv():
	inventory.sort_custom(sortByType)
