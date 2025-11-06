extends Node2D

@export var itemName = ""
@export var itemType = ""
@export var itemTexture = Texture
@export var itemEffect = ""
@export var pointTotals:Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
var scenePath: String = "res://Scenes/inventoryItem.tscn"

@onready var iconSprite = $TextureRect

var playerInRange = false

var ingredientTotals = { # collapse when not in use
# Elements:  W  E  F  A  L  D  M  B  S
	"None": [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"Sulfur": [5, 5, 5, 5, 0, 0, 30, 0, 0],
	"Mercury": [5, 5, 5, 5, 0, 0, 0, 30, 0],
	"Salt": [5, 5, 5, 5, 0, 0, 0, 0, 30],
	"Grapevine": [20, 0, 0, 0, 25, 0, 0, 0, 5],
	"Cherry Pits": [0, 10, 5, 0, 0, 5, 15, 0, 15],
	"Daisy": [0, 0, 0, 0, 0, 0, 0, 0, 0], # TODO input all point totals from sheet
	"Mandrake": [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"Hemlock": [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"Wolfsbane": [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"Henbane": [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"Bergamot": [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"Catnip": [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"Star Anise": [0, 0, 0, 0, 0, 0, 0, 0, 0],
	"Dandelion": [0, 0, 0, 0, 0, 0, 0, 0, 0]
}

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
		"name": itemName,
		"type": itemType,
		"effect": itemEffect,
		"quantity": 1,
		"texture": itemTexture,
		"scenePath": scenePath,
		"pointTotals": pointTotals
	}
	if GlobalInventory.playerNode:
		GlobalInventory.addItem(item)
		self.queue_free() # unload item from scene
	var tempItem = GlobalInventory.getItem(0)
	GlobalInventory.addItem(tempItem) # stupid fix for sorting inventory
	GlobalInventory.removeItem(tempItem["name"], tempItem["type"])
	assignPointTotals(item["name"])

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = true
		body.interactUI.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = false
		body.interactUI.visible = false

func assignPointTotals(key):
	for i in range(self["pointTotals"].size()):
		print("Filling in point totals")
		self["pointTotals"][i] = ingredientTotals[key][i]
	print("Point totals: ", self["pointTotals"])
	
