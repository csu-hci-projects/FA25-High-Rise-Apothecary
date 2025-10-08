extends Node

var inventory = []

signal inventoryUpdated

var playerNode: Node = null

@onready var inventorySlotScene = preload("res://Scenes/inventorySlot.tscn")

func _ready() -> void:
	inventory.resize(30)

func setPlayerNode(player):
	playerNode = player

func addItem(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["name"] == item["name"]: # if this item is already in the inventory
			inventory[i]["quantity"] += item["quantity"]
			inventoryUpdated.emit()
			print("Inventory item added to existing slot")
			return true
		elif inventory[i] == null: # if there is an empty slot
			inventory[i] = item
			inventoryUpdated.emit()
			print("Inventory item added to new slot")
			return true
		print("No inventory space")
		return false

func removeItem():
	inventoryUpdated.emit()

func increaseInvSize():
	inventoryUpdated.emit()
