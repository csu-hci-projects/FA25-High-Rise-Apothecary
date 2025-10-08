extends Node

var inventory = []

signal inventoryUpdated

var playerNode: Node = null

func _ready() -> void:
	inventory.resize(30)

func setPlayerNode(player):
	playerNode = player

func addItem():
	inventoryUpdated.emit()

func removeItem():
	inventoryUpdated.emit()

func increaseInvSize():
	inventoryUpdated.emit()
