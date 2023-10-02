extends Node2D
var node = AudioStreamPlayer2D.new()
var node2 = AudioStreamPlayer2D.new()
var score = 0
var scoreText
signal respawn

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(node)
	add_child(node2)
	scoreText = get_node("/root/Node2D/interface/Label")


func onDeath():
	node.stream = preload("res://audio/explosion.wav")
	node.play()
	global.deaths += 1
	score += 100
	scoreText.text = str(score)
	if global.deaths%10 == 0:
		node2.stream = preload("res://audio/chimep.wav")
		node2.play()
		respawn.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
