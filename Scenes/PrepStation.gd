extends Node2D

@onready var sprite = %Sprite2D
var spriteTexture = Texture
var ingredientTexture = Texture
var currentItem = GlobalInventory.createItem("nullName", 1, "nullType", "nullEffect")

@export var stationType = ""

@onready var stationMenu = %StationMenu
@onready var stationTextureRect = %StationTextureRect
@onready var ingredientTextureRect = %IngredientTextureRect
@onready var ingredientLabel = %IngredientLabel
@export_file_path() var ingredientTexturePath = ""
@export_file_path() var spriteTexturePath = ""


const itemScene = preload("res://Scenes/inventoryItem.tscn")

signal itemSent(item)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var interactNode = get_node("Interactable") # connect to child interactable component
	if interactNode:
		interactNode.interacted.connect(_on_interacted)
	
	GlobalInventory.itemSent.connect(itemSent.emit) # connect with inventory's item signal
	itemSent.connect(_on_itemSent)
	
	if not Engine.is_editor_hint():
		spriteTexture = load(spriteTexturePath)
		sprite.texture = spriteTexture
	
	updateSprite()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_interacted():
	if Globals.openUI == "none":
		openStationUI()
	elif Globals.openUI == "station":
		openStationUI()

func openStationUI():
	Globals.changeUI("station")
	stationMenu.visible = !stationMenu.visible

func _on_itemSent(item):
	if Globals.openUI.contains("station") and stationMenu.visible:
		insertItem(item)

func insertItem(item):
	var niName = item.itemName if item is InventoryItem else item["name"]
	var niType = item.itemType if item is InventoryItem else item["type"]
	if niType == "Ingredient":
		currentItem = item.duplicate()
		ingredientLabel.text = niName
		updateSprite()
	else:
		push_error("!ERROR! Noningredient attempted to add to station!")

func updateSprite():
	spriteTexture = load(spriteTexturePath)
	sprite.texture = spriteTexture
	stationTextureRect.texture = spriteTexture
	
	var iName = currentItem.itemName if currentItem is InventoryItem else currentItem["name"]
	if iName != "nullName":
		#ingredientTexturePath = "res://Assets/Sprites/Ingredients" + iName + ".png"
		ingredientTexturePath = "res://Assets/Sprites/Ingredients/pouch.png"
	if ingredientTexturePath != "":
		ingredientTexture = load(ingredientTexturePath)
		ingredientTextureRect.texture = ingredientTexture

func _on_prepare_button_pressed() -> void:
	var iName = currentItem.itemName if currentItem is InventoryItem else currentItem["name"]
	if iName != "nullName":
		prepare()

func prepare():
	match stationType:
		"pestle":
			currentItem.changePoints("earth", 15)
			currentItem.changePoints("air", -15)
			GlobalInventory.setShaderColor(Color(0.431, 0.631, 0.431, 1.0))
		"stove":
			currentItem.changePoints("fire", 15)
			currentItem.changePoints("dark", -15)
			GlobalInventory.setShaderColor(Color(0.824, 0.333, 0.341, 1.0))
		"cleaver":
			currentItem.changePoints("dark", 15)
			currentItem.changePoints("earth", -15)
			GlobalInventory.setShaderColor(Color(0.361, 0.263, 0.396, 1.0))
		"freezer":
			currentItem.changePoints("water", 15)
			currentItem.changePoints("light", -15)
			GlobalInventory.setShaderColor(Color(0.482, 0.596, 0.671, 1.0))
		"air fryer":
			currentItem.changePoints("air", 15)
			currentItem.changePoints("water", -15)
			GlobalInventory.setShaderColor(Color(0.847, 0.847, 0.847, 1.0))
		"sunning":
			currentItem.changePoints("light", 15)
			currentItem.changePoints("fire", -15)
			GlobalInventory.setShaderColor(Color(0.839, 0.812, 0.584, 1.0))
	GlobalInventory.pointsUpdated.emit()
	var iName = currentItem.itemName if currentItem is InventoryItem else currentItem["name"]
	var iType = currentItem.itemType if currentItem is InventoryItem else currentItem["type"]
	GlobalInventory.removeItem(iName, iType)
	currentItem.itemType = "Prepared Ingredient"
	currentItem.itemQuantity = 1
	ingredientTexturePath = "res://Assets/Sprites/Ingredients/pouch.png"
	#ingredientTexturePath = "res://Assets/Sprites/Ingredients/" + iName + ".png"
	currentItem.itemTexture = load(ingredientTexturePath)
	GlobalInventory.addItem(currentItem)
	GlobalInventory.inventoryUpdated.emit()
	currentItem = GlobalInventory.createItem("nullName", 1, "nullType", "nullEffect")
	updateSprite()
	ingredientTextureRect.texture = null
	ingredientLabel.text = "None"
