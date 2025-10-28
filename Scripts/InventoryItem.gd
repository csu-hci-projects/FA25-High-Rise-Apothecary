extends Node2D

@export var itemName = ""
@export var itemType = ""
@export var itemTexture = AtlasTexture
@export var itemEffect = ""
var scenePath: String = "res://Scenes/inventoryItem.tscn"

@onready var iconSprite = $TextureRect

var playerInRange = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		iconSprite.texture = itemTexture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		iconSprite.texture = itemTexture
	
	# add item to inventory if player in range and press 'E'
	if playerInRange and Input.is_action_just_pressed("AddUI"):
		pickupItem()

func pickupItem():
	var item = { # dictionary of item values
		"quantity": 1,
		"type": itemType,
		"name": itemName,
		"effect": itemEffect,
		"texture": itemTexture,
		"scenePath": scenePath
	}
	if GlobalInventory.playerNode:
		GlobalInventory.addItem(item)
		self.queue_free() # unload item from scene
	var tempItem = GlobalInventory.getItem(0)
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
