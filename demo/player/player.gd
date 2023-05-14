extends QuestieCharacter

export(float) var speed = 1.0
var velocity = Vector2()

func _process(_delta):

	velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

	if Input.is_action_pressed("ui_right"):
		velocity.x += speed

	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed

	if Input.is_action_pressed("ui_down"):
		velocity.y += speed

	velocity = move_and_slide(velocity)
	

