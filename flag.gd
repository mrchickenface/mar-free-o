extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	print("Player:")
	print(body.position)
	print("Flag:")
	print(self.position)
	if body.is_in_group("Player"):
		if body.position.y < self.position.y:
			global.score += 10
		if body.position.y < self.position.y-self.position.y/5:
			global.score += 10
		if body.position.y < self.position.y-self.position.y/5*2:
			global.score += 10
		if body.position.y < self.position.y-self.position.y/5*3:
			global.score += 10
		if body.position.y < self.position.y-self.position.y/5*4:
			global.score += 10
	$AnimationPlayer.play("win")
