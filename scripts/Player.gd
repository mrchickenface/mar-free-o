extends CharacterBody2D


var SPEED = 100
var JUMP_VELOCITY = -350.0
var inversed = false
var radished = false
var invincible = false
var climbing = false
var climbdir = 0
var postclimb = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var frames = ["default", "run", "jump", "skrrt", "die"]

func _physics_process(delta):
	if global.can_move:
		# Add the gravity.
		if not is_on_floor() and not climbing:
			velocity.y += gravity * delta
		elif not is_on_floor():
			velocity.y += gravity * delta / 5
		elif is_on_floor():
			postclimb = false
	
		# Handle Jump.
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play(frames[2])
		if Input.is_action_just_pressed("ui_up") and climbing: 
			postclimb = true
			velocity.y = JUMP_VELOCITY
			velocity.x = climbdir * SPEED
		if Input.is_action_just_released("ui_up"):
			if velocity.y < -100:
				velocity.y = -100
		if Input.is_action_just_pressed("ui_left"):
			$AnimatedSprite2D.flip_h = true
			postclimb = false
		if Input.is_action_just_pressed("ui_right"):
			$AnimatedSprite2D.flip_h = false
			postclimb = false
		if Input.is_action_just_pressed("ui_left") and is_on_floor() and not Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play(frames[1])
		if Input.is_action_just_pressed("ui_right") and is_on_floor() and not Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play(frames[1])
		if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_up") and is_on_floor():
			$AnimatedSprite2D.play(frames[0])
		if is_on_floor() and $AnimatedSprite2D.animation == "jump" and not Input.is_action_just_pressed("ui_up") or is_on_floor() and $AnimatedSprite2D.animation == "invertijump" and not Input.is_action_just_pressed("ui_up"):
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				$AnimatedSprite2D.play(frames[1])
			else:
				$AnimatedSprite2D.play(frames[0])
	
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction and not postclimb:
			velocity.x = direction * SPEED
		elif not postclimb:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
		move_and_slide()

func soup():
	SPEED = 150
	JUMP_VELOCITY = -400
	frames = ["inverted", "invertirun", "invertijump", "invertiskrrt", "invertidie"]
	inversed = true

func damage():
	if inversed or radished and not invincible:
		print("hurt!")
		SPEED = 100
		JUMP_VELOCITY = -350.0
		frames = ["default", "run", "jump", "skrrt", "die"]
		$AnimatedSprite2D.scale = Vector2(1,1)
		$CollisionShape2D.scale = Vector2(1,1)
		inversed = false
		radished = false
		invincible = true
		await get_tree().create_timer(.25).timeout
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(.25).timeout
		$AnimatedSprite2D.show()
		await get_tree().create_timer(.25).timeout
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(.25).timeout
		$AnimatedSprite2D.show()
		invincible = false
	elif not invincible:
		print("died!")
		global.can_move = false
		self.get_node("AnimatedSprite2D").play(self.frames[4])
		self.get_node("AnimationPlayer").play("die")
		await self.get_node("AnimationPlayer").animation_finished
		global.death()

func radish():
	$AnimatedSprite2D.scale = Vector2(1.5,1.5)
	$CollisionShape2D.scale = Vector2(1.5,1.5)
	radished = true

func bounce():
	if not inversed and not radished:
		velocity.y = JUMP_VELOCITY / 1.25
	elif inversed and not radished:
		velocity.y = JUMP_VELOCITY
	$AnimatedSprite2D.play(frames[2])


func _on_area_2d_body_entered(body):
	if not is_on_floor() and body.is_in_group("Level"):
		if $RayCast2D2.is_colliding():
			print(body)
			velocity.y = 0
			climbing = true
			climbdir = 1
			$AnimatedSprite2D.play("skrrt")
			$AnimatedSprite2D.flip_h = false


func _on_area_2d_body_exited(body):
	if body.is_in_group("Level"):
		climbing = false


func _on_area_2d_2_body_entered(body):
	if not is_on_floor() and body.is_in_group("Level"):
		if $RayCast2D.is_colliding():
			print(body)
			velocity.y = 0
			climbing = true
			climbdir = -1
			$AnimatedSprite2D.play("skrrt")
			$AnimatedSprite2D.flip_h = true


func _on_area_2d_2_body_exited(body):
	if body.is_in_group("Level"):
		climbing = false
