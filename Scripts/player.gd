extends CharacterBody2D

var speed = 100
var money = 1000

@onready var animatedSprite = $AnimatedSprite2D
@onready var interactUI = $InteractUI
@onready var inventoryUI = $InventoryUI
@onready var moneyLabel = $MoneyUI/Label

func _ready() -> void:
	GlobalInventory.setPlayerNode(self)
	changeBalance(0)

func getInput():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction and Globals.openUI == "none":
		self.velocity = direction * speed
	else:
		self.velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	getInput()
	move_and_slide()
	updateAnimations()

func updateAnimations():
	if velocity == Vector2.ZERO:
		animatedSprite.play("idle")
	else:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animatedSprite.play("walkRight")
			else:
				animatedSprite.play("walkLeft")
		else:
			if velocity.y > 0:
				animatedSprite.play("walkDown")
			else:
				animatedSprite.play("walkUp")

func _input(event):
	if event.is_action_pressed("InventoryUI"):
		inventoryUI.visible = !inventoryUI.visible
		get_tree().paused = !get_tree().paused
		Globals.changeUI("inv")

func changeBalance(amount):
	money += amount
	moneyLabel.text = "$" + str(money)
