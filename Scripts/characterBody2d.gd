extends CharacterBody2D

const speed = 100

func _physics_process(_delta: float) -> void:
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity = direction * speed
	else:
		self.velocity = Vector2.ZERO
	
	move_and_slide()
