extends Node2D
class_name InventoryItem

@export var itemName = ""
@export var itemType = ""
@export_file_path() var itemTexturePath = ""
var itemTexture = Texture
@export var itemEffect = ""
@export var pointTotals:Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
@export var potionTier = 0
@export var itemQuantity = 1

var scenePath: String = "res://Scenes/inventoryItem.tscn"

@onready var iconSprite = $TextureRect

var playerInRange = false

var ingredientTotals = { # collapse when not editing
# Elements:  W  E  F  A  L  D  M  B  S
	"None": [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"Sulfur": [5, 5, 5, 5, 0, 0, 30, 0, 0],
	"Mercury": [5, 5, 5, 5, 0, 0, 0, 30, 0],
	"Salt": [5, 5, 5, 5, 0, 0, 0, 0, 30],
	"Grapevine": [20, 0, 0, 0, 25, 0, 0, 0, 5],
	"Cherry Pits": [0, 10, 5, 0, 0, 5, 15, 0, 15],
	"Daisy": [10, 10, 0, 10, 15, 5, 0, 0, 0],
	"Mandrake": [15, 5, 5, 0, 0, 0, 10, 10, 0],
	"Hemlock": [10, 0, 0, 0, 20, 0, 10, 0, 10],
	"Wolfsbane": [0, 0, 15, 15, 5, 10, 0, 0, 0],
	"Henbane": [15, 0, 0, 5, 0, 0, 0, 15, 15],
	"Bergamot": [5, 0, 15, 0, 0, 0, 30, 0, 0],
	"Catnip": [0, 5, 5, 5, 15, 15, 0, 0, 5],
	"Star Anise": [0, 0, 30, 0, 0, 0, 0, 20, 0],
	"Dandelion": [0, 20, 0, 25, 0, 5, 0, 0, 0]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		iconSprite.texture = load(itemTexturePath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		iconSprite.texture = itemTexture
	# add item to inventory if player in range and press 'E'
	if playerInRange and Input.is_action_just_pressed("AddUI"):
		pickupItem()

func pickupItem():
	var item = { # dictionary of item values
		"name": itemName,
		"type": itemType,
		"effect": itemEffect,
		"quantity": itemQuantity,
		"texturePath": itemTexturePath,
		"scenePath": scenePath,
		"pointTotals": pointTotals,
		"tier": potionTier
	}
	if GlobalInventory.playerNode:
		GlobalInventory.addItem(item)
		self.queue_free() # unload item from scene
	if item["type"] == "Ingredient":
		assignPointTotals(item["name"])
	if itemType.contains("Ingredient"):
		itemEffect = setEffect()
	var tempItem = GlobalInventory.getItemDupe(0)
	if tempItem is InventoryItem:
		tempItem.itemQuantity = 1
		GlobalInventory.addItem(tempItem) # stupid fix for sorting inventory
		GlobalInventory.removeItem(tempItem.itemName, tempItem.itemType)
	else:
		tempItem["quantity"] = 1
		GlobalInventory.addItem(tempItem) # stupid fix for sorting inventory
		GlobalInventory.removeItem(tempItem["name"], tempItem["type"])
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = true
		body.interactUI.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = false
		body.interactUI.visible = false

func assignPointTotals(key: String):
	var iPointTotals = self.pointTotals if self is InventoryItem else self["pointTotals"]
	for i in range(iPointTotals.size()):
		iPointTotals[i] = ingredientTotals[key][i]

func setItemData(data: Dictionary):
	itemName = data["name"]
	itemType = data["type"]
	itemEffect = data["effect"]
	itemTexture = data["texture"]
	if data["tier"] != null:
		potionTier = data["tier"]
	if data["pointTotals"] != null:
		pointTotals = data["pointTotals"]

func initiateItem(newItemName: String, newItemType: String, newItemEffect: String, newItemTexturePath: String, newItemQuantity: int, newItemTier, newItemPoints):
	itemName = newItemName
	itemType = newItemType
	itemEffect = newItemEffect
	itemTexturePath = newItemTexturePath
	itemQuantity = newItemQuantity
	if newItemTier != null:
		potionTier = newItemTier
	if newItemPoints != null:
		pointTotals = newItemPoints

func setTexture(newTexturePath: String):
	itemTexture = load(newTexturePath)
	
func increaseWater():
	pointTotals[0] += 10

func setEffect():
	var effect = ""
	effect += "Water: {str(pointTotals[0])}, "
	effect += "Earth: {str(pointTotals[1])}, "
	effect += "Fire: {str(pointTotals[2])}, \n"
	effect += "Air: {str(pointTotals[3])}, "
	effect += "Light: {str(pointTotals[4])}, "
	effect += "Dark: {str(pointTotals[5])}, \n"
	effect += "Mind: {str(pointTotals[6])}, "
	effect += "Body: {str(pointTotals[7])}, "
	effect += "Spirit: {str(pointTotals[8])}"
	return effect
