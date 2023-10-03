extends Node2D
var node = AudioStreamPlayer2D.new()
var node2 = AudioStreamPlayer2D.new()
var score = 0
var scoreText
var livesText
var waveText
signal respawn
var enemiesScript
var hasLost = false
var ship
var respawning

# Called when the node enters the scene tree for the first time.
func _ready():
	respawning = false
	add_child(node)
	add_child(node2)
	scoreText = get_node("/root/Node2D/interface/Label")
	livesText = get_node("/root/Node2D/interface/Label2")
	waveText = get_node("/root/Node2D/interface/Label3")
	enemiesScript = get_node("/root/Node2D/enemies")
	ship = get_node("/root/Node2D/player")
	enemiesScript.loser.connect(loseState)
	ship.lifeCounterUpdate.connect(lifecount)


func onDeath():
	node.stream = preload("res://audio/explosion.wav")
	node.play()
	global.deaths += 1
	score += 100
	scoreText.text = "SCORE: " + str(score)
	if global.deaths%10 == 0:
		node2.stream = preload("res://audio/chimep.wav")
		node2.play()
		await get_tree().create_timer(2).timeout
		respawn.emit()

func loseState():
	ship.onPlayerDeath()
	await get_tree().create_timer(1).timeout
	node2.stream = preload("res://audio/deathchime.wav")
	node2.play()

func lifecount():
	livesText.text = "LIVES: " + str(global.lives)
	respawning = true
	global.deaths = 0
	if global.lives <= 0:
		waveText.text = "GAME OVER"
		return
	elif global.lives > 0:
		respawn.emit()

func waveUpdate():
	waveText.text = "WAVE: " + str(global.wave)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
