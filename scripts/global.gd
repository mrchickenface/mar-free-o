extends Node

var score = 0
var can_move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart():
	global.can_move = true
	get_tree().reload_current_scene()
