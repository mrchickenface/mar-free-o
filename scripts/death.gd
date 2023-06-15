extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		global.can_move = false
		body.get_node("AnimatedSprite2D").play(body.frames[4])
		body.get_node("AnimationPlayer").play("die")
		await body.get_node("AnimationPlayer").animation_finished
		await get_tree().create_timer(1).timeout
		global.restart()
