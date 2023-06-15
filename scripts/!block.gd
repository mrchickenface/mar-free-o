extends Node2D

@export var contains = ""
@export var active = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and active == true:
		$block/AnimatedSprite2D.play("deactivated")
		active = false
		var powerload = load(contains)
		var powerup = powerload.instantiate()
		add_child(powerup)
		print("gave powerup!")
