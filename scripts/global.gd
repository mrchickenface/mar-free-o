extends Node

var score = 0
var can_move = true
var level_id = 01

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart():
	global.can_move = true
	get_tree().reload_current_scene()

func death():
	can_move = false
	await get_tree().create_timer(1).timeout
	can_move = true
	get_tree().reload_current_scene()
