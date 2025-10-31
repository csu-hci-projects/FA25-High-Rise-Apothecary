extends Node2D

@export var tileType = ""
@export var tileName = ""
@export var tileTexture = Texture2D
@export var tileEffect = ""
var scenePath: String = "res://Scenes/InteractPoint.tscn"

var playerInRange = false
signal interacted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	checkInteract()

func checkInteract():
	if playerInRange and Input.is_action_just_pressed("AddUI"):
		interacted.emit()

# ~~~ Parent code to connect signal, in ready ~~~
# var childNode = get_node("Interactable")
# if childNode:
#	childNode.connect("interacted", self, "_on_interacted")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = true
		body.interactUI.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"): # check if player is what's colliding
		playerInRange = false
		body.interactUI.visible = false
