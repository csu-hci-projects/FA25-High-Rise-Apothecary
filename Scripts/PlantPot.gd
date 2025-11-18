extends Node2D

@onready var sprite = %Sprite2D
var spriteTexture = Texture
@export_file_path() var spriteTexturePath = "res://Assets/Sprites/Environment/empty pot.png"
var currentPlant = createItem()
@export_file_path() var plantTexturePath = ""
@export var plantReady = true
var spriteChanged = false

var playerInRange = false

const itemScene = preload("res://Scenes/inventoryItem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var interactNode = get_node("Interactable") # connect to child interactable component
	if interactNode:
		interactNode.interacted.connect(_on_interacted)
	GlobalTime.timePasses.connect(_on_time_passed)
	if not Engine.is_editor_hint():
		spriteTexture = load(spriteTexturePath)
		sprite.texture = spriteTexture
	updateSprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		sprite.texture = spriteTexture
	if spriteChanged:
		updateSprite()

func _on_interacted():
	spriteChanged = true
	plantReady = false

func _on_time_passed():
	plantReady = true
	spriteChanged = true

func updateSprite():
	if currentPlant != null:
		var iName = currentPlant.itemName
		plantTexturePath = "res://Assets/Sprites/Ingredients" + iName + ".png"
		spriteTexturePath = "res://Assets/Sprites/Environment/planted pot.png"
	else:
		spriteTexturePath = "res://Assets/Sprites/Environment/empty pot.png"
	if plantReady:
		spriteTexturePath = "res://Assets/Sprites/Environment/ready pot.png"
	spriteTexture = load(spriteTexturePath)
	sprite.texture = spriteTexture
	spriteChanged = false

func createItem():
	var newItem = itemScene.instantiate()
	newItem.initiateItem("name", "type", "effect", "res://Assets/icon.svg", null, null)
	return newItem
