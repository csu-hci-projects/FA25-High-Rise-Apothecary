extends CharacterBody2D

const speed = 100

@onready var animatedSprite = $AnimatedSprite2D

func _ready() -> void:
	GlobalInventory.setPlayerNode(self)

func getInput():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
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
