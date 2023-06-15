extends CharacterBody2D


var SPEED = 100
var JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var frames = ["default", "run", "jump", "skrrt", "die"]

func _physics_process(delta):
	if global.can_move:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
	
		# Handle Jump.
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play(frames[2])
		if Input.is_action_just_released("ui_up"):
			if velocity.y < -100:
				velocity.y = -100
		if Input.is_action_just_pressed("ui_left"):
			$AnimatedSprite2D.flip_h = true
		if Input.is_action_just_pressed("ui_right"):
			$AnimatedSprite2D.flip_h = false
		if Input.is_action_just_pressed("ui_left") and is_on_floor() and not Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play(frames[1])
		if Input.is_action_just_pressed("ui_right") and is_on_floor() and not Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play(frames[1])
		if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_up") and is_on_floor():
			$AnimatedSprite2D.play(frames[0])
		if is_on_floor() and $AnimatedSprite2D.animation == "jump" and not Input.is_action_just_pressed("ui_up"):
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				$AnimatedSprite2D.play(frames[1])
			else:
				$AnimatedSprite2D.play(frames[0])
	
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
		move_and_slide()

func soup():
	SPEED = 150
	JUMP_VELOCITY = -400
	frames = ["inverted", "invertirun", "invertijump", "invertiskrrt", "invertidie"]
