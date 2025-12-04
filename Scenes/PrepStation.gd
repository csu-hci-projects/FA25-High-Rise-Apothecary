extends Node2D

@onready var sprite = %Sprite2D
var spriteTexture = Texture
var currentItem = GlobalInventory.createItem("nullName")

@export var stationType = ""

@onready var stationMenu = %StationMenu
@onready var stationTextureRect = %StationTextureRect
@onready var ingredientTextureRect = %IngredientTextureRect
@onready var ingredientLabel = %IngredientLabel

const itemScene = preload("res://Scenes/inventoryItem.tscn")

signal itemSent(item)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var interactNode = get_node("Interactable") # connect to child interactable component
	if interactNode:
		interactNode.interacted.connect(_on_interacted)
	
	GlobalInventory.itemSent.connect(itemSent.emit) # connect with inventory's item signal
	itemSent.connect(_on_itemSent)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	pass
