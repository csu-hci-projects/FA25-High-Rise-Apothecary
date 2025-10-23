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
			print("Inventory item added to existing slot")
			inventoryUpdated.emit()
			return true
		elif inventory[i] == null: # if there is an empty slot
			inventory[i] = item
			print("Inventory item added to new slot")
			inventoryUpdated.emit()
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

func sortInv2():
	for j in range(inventory.size()):
		for i in range(j):
			if inventory[i] != null and inventory[i+1] != null:
				if inventory[i]["type"] > inventory[i+1]["type"]:
					var tempItem = inventory[i+1]
					inventory[i+1] = inventory[i]
					inventory[i] = tempItem

func scootItems():
	for i in range(inventory.size()-1):
		if inventory[i] == null and inventory[i+1] != null:
			inventory[i] = inventory[i+1]
			inventory[i+1] = null
