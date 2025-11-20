extends Node2D

@onready var sprite = %Sprite2D
var spriteTexture = Texture
@export_file_path() var spriteTexturePath = "res://Assets/Sprites/Environment/empty pot.png"
var currentPlant = createItem()
@export_file_path() var plantTexturePath = ""
@export var plantReady = true

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
	GlobalTime.timePasses.connect(_on_time_passed)
	if not Engine.is_editor_hint():
		spriteTexture = load(spriteTexturePath)
		sprite.texture = spriteTexture
	_on_time_passed()
	updateSprite()
	assignPlantValues("Catnip")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		sprite.texture = spriteTexture

func _on_interacted():
	if currentPlant.itemName == "nullName":
		openPlanterUI()
	else:
		if plantReady:
			harvestPlant()
			updateSprite()

func _on_time_passed():
	plantReady = true
	updateSprite()

func updateSprite():
	if currentPlant.itemName != "nullName":
		var iName = currentPlant.itemName
		plantTexturePath = "res://Assets/Sprites/Ingredients" + iName + ".png"
		spriteTexturePath = plantedPath
	else:
		spriteTexturePath = emptyPath
	if plantReady:
		spriteTexturePath = readyPath
	spriteTexture = load(spriteTexturePath)
	sprite.texture = spriteTexture

func createItem():
	var newItem = itemScene.instantiate()
	newItem.initiateItem("nullName", "Ingredient", "nullEffect", "res://Assets/icon.svg", 5, null, null)
	return newItem

func assignPlantValues(plantName):
	currentPlant.itemName = plantName
	#currentPlant.itemTexturePath = "res://Assets/Sprites/Ingredients/" + plantName + ".png"
	var texturePath = "res://Assets/Sprites/Ingredients/pouch.png"
	currentPlant.itemTexturePath = texturePath
	currentPlant.itemTexture = load(texturePath)
	currentPlant.assignPointTotals(plantName)

func openPlanterUI():
	pass

func harvestPlant():
	GlobalInventory.addItem(currentPlant)
	plantReady = false
