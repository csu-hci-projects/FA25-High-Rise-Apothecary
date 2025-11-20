extends Node2D

enum Element {
	WATER,
	EARTH,
	FIRE,
	AIR,
	LIGHT,
	DARK,
}
enum Aspect {
	MIND,
	BODY,
	SPIRIT
}
var pointTotals:Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]

@onready var potMenu = %PotMenu
@onready var waterLabel = %WaterLabel
@onready var earthLabel = %EarthLabel
@onready var fireLabel = %FireLabel
@onready var airLabel = %AirLabel
@onready var lightLabel = %LightLabel
@onready var darkLabel = %DarkLabel
@onready var mindLabel = %MindLabel
@onready var bodyLabel = %BodyLabel
@onready var spiritLabel = %SpiritLabel

signal itemSent(item)

const itemScene = preload("res://Scenes/inventoryItem.tscn")

var potionTable = []
var tableHeight = 3
var tableWidth = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var interactNode = get_node("Interactable") # connect to child interactable component
	if interactNode:
		interactNode.interacted.connect(_on_interacted)
	
	GlobalInventory.itemSent.connect(itemSent.emit) # connect with inventory's item signal
	itemSent.connect(_on_itemSent)
	
	potionTable = createPotionGrid(potionTable, tableWidth, tableHeight) # create 2D array of potions

func _on_interacted():
	Globals.changeUI("pot")
	potMenu.visible = !potMenu.visible

func createPotionGrid(grid: Array, gridWidth: int, gridHeight: int):
	for i in gridHeight:
		grid.append([])
		for j in gridWidth:
			grid[i].append("null")
	grid[Aspect.MIND][Element.WATER] = "sleep"
	grid[Aspect.BODY][Element.WATER] = "healing"
	grid[Aspect.SPIRIT][Element.WATER] = "charisma"
	grid[Aspect.MIND][Element.EARTH] = "concentration"
	grid[Aspect.BODY][Element.EARTH] = "defense"
	grid[Aspect.SPIRIT][Element.EARTH] = "growth"
	grid[Aspect.MIND][Element.FIRE] = "motivation"
	grid[Aspect.BODY][Element.FIRE] = "attack"
	grid[Aspect.SPIRIT][Element.FIRE] = "creativity"
	grid[Aspect.MIND][Element.AIR] = "intelligence"
	grid[Aspect.BODY][Element.AIR] = "swiftness"
	grid[Aspect.SPIRIT][Element.AIR] = "truth"
	grid[Aspect.MIND][Element.LIGHT] = "dreams"
	grid[Aspect.BODY][Element.LIGHT] = "levitation"
	grid[Aspect.SPIRIT][Element.LIGHT] = "luck"
	grid[Aspect.MIND][Element.DARK] = "nightmares"
	grid[Aspect.BODY][Element.DARK] = "poison"
	grid[Aspect.SPIRIT][Element.DARK] = "curse"
	return grid

func addIngredient(addedItem):
	var iType = addedItem.itemType if addedItem is InventoryItem else addedItem["type"]
	var iTotals = addedItem.pointTotals if addedItem is InventoryItem else addedItem["pointTotals"]
	if iType.contains("Ingredient"):
		for i in range(iTotals.size()):
			pointTotals[i] += iTotals[i]
		updateTotals()
	else:
		push_error("!ERROR! Noningredient attempted to add to pot!")

func updateTotals():
	waterLabel.text = "Water: " + str(pointTotals[Element.WATER])
	earthLabel.text = "Earth: " + str(pointTotals[Element.EARTH])
	fireLabel.text = "Fire: " + str(pointTotals[Element.FIRE])
	airLabel.text = "Air: " + str(pointTotals[Element.AIR])
	lightLabel.text = "Light: " + str(pointTotals[Element.LIGHT])
	darkLabel.text = "Dark: " + str(pointTotals[Element.DARK])
	mindLabel.text = "Mind: " + str(pointTotals[Aspect.MIND+6])
	bodyLabel.text = "Body: " + str(pointTotals[Aspect.BODY+6])
	spiritLabel.text = "Spirit: " + str(pointTotals[Aspect.SPIRIT+6])

func _on_itemSent(item):
	if Globals.openUI.contains("pot"):
		addIngredient(item)
		var iName = item.itemName if item is InventoryItem else item["name"]
		var iType = item.itemType if item is InventoryItem else item["type"]
		GlobalInventory.removeItem(iName, iType)

func _on_button_pressed() -> void:
	if sumPoints(0, pointTotals.size()) > 0:
		if verifyMinimums(pointTotals, 0, 6, 10) and verifyMinimums(pointTotals, 6, 9, 1):
			var maxElements = findMaximums(pointTotals, 0, 6)
			var maxAspects = findMaximums(pointTotals, 6, 9)
			var chosenElement = maxElements.pick_random()
			var chosenAspect = maxAspects.pick_random()
			var createdPotion = createItem()
			var potionName = determinePotion(chosenAspect, chosenElement)
			var potionTier = determineTier()
			createdPotion = assignPotionValues(createdPotion, potionName, potionTier)
			GlobalInventory.addItem(createdPotion)
			GlobalInventory.inventoryUpdated.emit() # fix sorting
			pointTotals = [0, 0, 0, 0, 0, 0, 0, 0, 0]
			updateTotals()
		else:
			print("Not enough elemental or aspect points!")
	else:
		print("No ingredients in cauldron!")

func findMaximums(array: Array, startIndex: int, endIndex: int):
	var maxValue = 0
	var maxIndexes = []
	for i in range(startIndex, endIndex):
		if array[i] > maxValue:
			maxValue = array[i]
			maxIndexes = [i]
		elif array[i] == maxValue:
			maxIndexes.append(i)
	return maxIndexes

func verifyMinimums(array: Array, startIndex: int, endIndex: int, minimum: int):
	for i in range(startIndex, endIndex):
		if array[i] >= minimum:
			return true # if at least one of the elements is over 10
	return false

func sumPoints(startIndex: int, endIndex: int):
	var totalSum = 0
	for i in range(startIndex, endIndex):
		totalSum += pointTotals[i]
	return totalSum

func determinePotion(chosenAspect: int, chosenElement: int):
	var potionName = potionTable[chosenAspect-6][chosenElement]
	return potionName

func determineTier():
	var totalSum = sumPoints(0, pointTotals.size())
	if totalSum >= 200:
		return 3
	elif totalSum >= 100:
		return 2
	else:
		return 1

func createItem():
	var newItem = itemScene.instantiate()
	newItem.initiateItem("name", "type", "effect", "res://Assets/icon.svg", 1, null, null)
	return newItem

func assignPotionValues(potionItem: InventoryItem, potionName: String, tier: int):
	potionItem.itemName = potionName.capitalize()
	potionItem.itemType = "Potion"
	var texturePath = "res://Assets/Sprites/Potions/" + potionName + ".png"
	potionItem.itemTexturePath = texturePath
	potionItem.itemTexture = load(texturePath)
	potionItem.itemEffect = "A tier " + str(tier) + " potion of " + potionName.capitalize() + "."
	return potionItem
