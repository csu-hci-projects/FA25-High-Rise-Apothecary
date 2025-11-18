extends Node

var inventory = []

signal inventoryUpdated
@warning_ignore("unused_signal")
signal itemSent

var playerNode: Node = null

@onready var inventorySlotScene = preload("res://Scenes/inventorySlot.tscn")

func _ready() -> void:
	inventory.resize(8)

func setPlayerNode(player):
	playerNode = player

func getItemDirect(slot):
	return inventory[slot]

func getItemDupe(slot):
	return inventory[slot].duplicate()

func addItem(item):
	for i in range(inventory.size()):
		if inventory[i] != null:
			var iName = inventory[i].itemName if inventory[i] is InventoryItem else inventory[i]["name"]
			var iType = inventory[i].itemType if inventory[i] is InventoryItem else inventory[i]["type"]
			var iQuantity = item.itemQuantity if item is InventoryItem else item["quantity"]
			if iType == "Potion":
				var iTier = inventory[i].potionTier if inventory[i] is InventoryItem else inventory[i]["tier"]
				if iName == item["name"] and iType == item["type"] and iTier == item["tier"]:
					inventory[i]["quantity"] += iQuantity
					inventoryUpdated.emit()
					return true
			else:
				if iName == item["name"] and iType == item["type"]: # if this item is already in the inventory
					inventory[i]["quantity"] += iQuantity
					inventoryUpdated.emit()
					return true
		elif inventory[i] == null: # if there is an empty slot
			inventory[i] = item
			inventoryUpdated.emit()
			return true
	changeInvSize(8) # only reached if no inv space
	if !addItem(item): # recursive call, should only happen once
		push_error("!ERROR! addItem not working!")
		return false

func removeItem(itemName, itemType):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == itemName and inventory[i]["type"] == itemType:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory.pop_at(i)
				changeInvSize(1)
			inventoryUpdated.emit()
			return true
	return false

func changeInvSize(slots):
	inventory.resize(inventory.size() + slots)
	inventoryUpdated.emit()

func sortInv():
	for j in range(inventory.size()):
		for i in range(j):
			if inventory[i] != null and inventory[i+1] != null:
				var iType = inventory[i].itemType if inventory[i] is InventoryItem else inventory[i]["type"]
				var i1Type = inventory[i+1].itemType if inventory[i+1] is InventoryItem else inventory[i+1]["type"]
				if iType > i1Type:
					var tempItem = inventory[i+1]
					inventory[i+1] = inventory[i]
					inventory[i] = tempItem
