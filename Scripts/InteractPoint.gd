extends Node2D

@export var tileType = ""
@export var tileName = ""
@export var tileTexture = Texture2D
@export var tileEffect = ""
var scenePath: String = "res://Scenes/InteractPoint.tscn"

@onready var iconSprite = $Sprite2D

@onready var interactablePopup = $InteractablePopup
var playerInRange = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if playerInRange and Input.is_action_just_pressed("AddUI"):
		interact()

func interact():
	var tile = { # dictionary of item values
		"quantity": 1,
		"type": tileType,
		"name": tileName,
		"effect": tileEffect,
		"texture": tileTexture,
		"scenePath": scenePath
	}
	if Globals.openUI == "none":
		print("Interacted!")
		Globals.openUI = tile["name"]
	elif Globals.openUI == tile["name"]:
		print("Closed!")
		Globals.openUI = "none"
	else:
		print("Interact points too close together!")
	interactablePopup.visible = !interactablePopup.visible

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = true
		body.interactUI.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = false
		body.interactUI.visible = false
