extends Node2D
var node = AudioStreamPlayer2D.new()
var score = 0
var scoreText

# Called when the node enters the scene tree for the first time.
func _ready():
	node.stream = preload("res://audio/wahwah.wav")
	add_child(node)
	scoreText = get_node("/root/Node2D/interface/Label")


func onDeath():
	node.play()
	global.deaths += 1
	score += 100
	scoreText.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
