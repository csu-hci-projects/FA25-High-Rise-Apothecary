extends Node2D

@onready var sprite = %Sprite2D
var spriteTexture = Texture
@export_file_path() var spriteTexturePath = "res://Assets/Sprites/Environment/empty pot.png"
var currentPlant = createItem("nullName")
var plantTexture = Texture
@export_file_path() var plantTexturePath = ""
@export var plantReady = true

@onready var planterMenu = %PlanterMenu
@onready var potTextureRect = %PotTextureRect
@onready var plantTextureRect = %PlantTextureRect
@onready var plantLabel = %PlantLabel

signal itemSent(item)
var playerInRange = false

const itemScene = preload("res://Scenes/inventoryItem.tscn")
const emptyPath = "res://Assets/Sprites/Environment/empty pot.png"
const plantedPath = "res://Assets/Sprites/Environment/planted pot.png"
const readyPath = "res://Assets/Sprites/Environment/ready pot.png"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var interactNode = get_node("Interactable") # connect to child interactable component
	if interactNode:
		interactNode.interacted.connect(_on_interacted)
	GlobalTime.timePasses.connect(_on_timePassed)
	GlobalInventory.itemSent.connect(itemSent.emit) # connect with inventory's item signal
	itemSent.connect(_on_itemSent)
	
	if not Engine.is_editor_hint():
		spriteTexture = load(spriteTexturePath)
		sprite.texture = spriteTexture
	
	updateSprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		sprite.texture = spriteTexture

func _on_interacted():
	if plantReady and Globals.openUI == "none":
		harvestPlant()
		updateSprite()
		resetAction()
	elif Globals.openUI == "none" and Globals.lastAction != "E":
		openPlanterUI()
	elif planterMenu.visible:
		openPlanterUI()
		resetAction()
	Globals.lastAction = "E"

func _on_timePassed():
	if currentPlant is InventoryItem:
		if currentPlant.itemName != "nullName":
			plantReady = true
			updateSprite()
	else:
		if currentPlant["name"] != "nullName":
			plantReady = true
			updateSprite()

func updateSprite():
	var iName = currentPlant.itemName if currentPlant is InventoryItem else currentPlant["name"]
	if iName != "nullName":
		#plantTexturePath = "res://Assets/Sprites/PLants" + iName + ".png"
		plantTexturePath = "res://Assets/Sprites/Ingredients/pouch.png"
		spriteTexturePath = plantedPath
	else:
		spriteTexturePath = emptyPath
	if plantReady:
		spriteTexturePath = readyPath
	spriteTexture = load(spriteTexturePath)
	sprite.texture = spriteTexture
	potTextureRect.texture = spriteTexture
	if plantTexturePath != "":
		plantTexture = load(plantTexturePath)
		plantTextureRect.texture = plantTexture

func createItem(itemName):
	var newItem = itemScene.instantiate()
	newItem.initiateItem(itemName, "Ingredient", "nullEffect", "res://Assets/icon.svg", 5, null, null)
	return newItem

func assignPlantValues(plantName):
	currentPlant.itemName = plantName
	#currentPlant.itemTexturePath = "res://Assets/Sprites/Ingredients/" + plantName + ".png"
	var texturePath = "res://Assets/Sprites/Ingredients/pouch.png"
	currentPlant.itemTexturePath = texturePath
	currentPlant.itemTexture = load(texturePath)
	if currentPlant is InventoryItem:
		currentPlant.assignPointTotals(plantName)

func openPlanterUI():
	Globals.changeUI("planter")
	planterMenu.visible = !planterMenu.visible

func _on_itemSent(item):
	if Globals.openUI.contains("planter") and planterMenu.visible:
		plantSeed(item)

func plantSeed(item):
	var iName = currentPlant.itemName if currentPlant is InventoryItem else currentPlant["name"]
	var niName = item.itemName if item is InventoryItem else item["name"]
	var niType = item.itemType if item is InventoryItem else item["type"]
	if iName == "nullName":
		if niType.contains("Seedling"):
			currentPlant = createItem(niName)
			plantTextureRect.texture = load(plantTexturePath)
			plantLabel.text = niName
			updateSprite()
			GlobalInventory.removeItem(niName, niType)
		else:
			push_error("!ERROR! Nonseedling attempted to add to planter!")
	else:
		print("Uproot current plant first!")

func harvestPlant():
	var harvestedPlant = currentPlant.duplicate()
	harvestedPlant.setTexture(plantTexturePath)
	harvestedPlant.assignPointTotals(harvestedPlant.itemName)
	GlobalInventory.addItem(harvestedPlant)
	GlobalInventory.inventoryUpdated.emit() #fixes sorting
	plantReady = false

func _on_uproot_button_pressed() -> void:
	currentPlant = createItem("nullName")
	updateSprite()
	plantTextureRect.texture = null
	plantLabel.text = "None"
	
func _on_grow_button_pressed() -> void:
	_on_timePassed()

func resetAction():
	await get_tree().create_timer(0.1).timeout
	Globals.lastAction = "null"
	print("Last action: " + Globals.lastAction)
