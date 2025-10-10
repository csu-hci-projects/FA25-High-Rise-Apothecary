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
	
	# add item to inventory if player in range and press 'E'
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
	print("Interacted!")
	interactablePopup.visible = !interactablePopup.visible

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = true
		body.interactUI.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = false
		body.interactUI.visible = false
