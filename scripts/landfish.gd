extends CharacterBody2D


const SPEED = 25.0
const JUMP_VELOCITY = -400.0
@export var direction = 1
var active = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not $RayCast2D.is_colliding() or not $RayCast2D2.is_colliding():
		direction *= -1
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * SPEED
	
	$AnimatedSprite2D.flip_h = -direction + 1

	if active:
		move_and_slide()


func _on_area_2d_2_body_entered(body):
	if body.is_in_group("Player") and active:
		body.damage()
	else:
		direction *= -1


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and active:
		if not body.radished:
			global.score += 10
		else:
			global.score += 20
		body.bounce()
		$AnimatedSprite2D.play("die")
		active = false
		set_collision_layer_value(1,false)
		set_collision_layer_value(2,true)
		await get_tree().create_timer(1).timeout
		queue_free()
