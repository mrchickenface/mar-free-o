extends Node2D

func _ready():
	global.score += 10
	$AnimationPlayer.play("collect")
