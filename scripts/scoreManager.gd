extends Node2D
var node = AudioStreamPlayer2D.new()
var node2 = AudioStreamPlayer2D.new()
var score = 0
var scoreText
var livesText
var waveText
var hitPercentText
signal respawn
var enemiesScript
var hasLost = false
var ship
var respawning
signal killStars
signal spawnStars
signal shipBonus
signal spawnAsteroids
signal stopAsteroids
signal clearBonus
var exitingBonus = false
# Called when the node enters the scene tree for the first time.
func _ready():
	respawning = false
	add_child(node)
	add_child(node2)
	scoreText = get_node("/root/Node2D/interface/Label")
	livesText = get_node("/root/Node2D/interface/Label2")
	waveText = get_node("/root/Node2D/interface/Label3")
	hitPercentText = get_node("/root/Node2D/interface/Label4")
	enemiesScript = get_node("/root/Node2D/enemies")
	ship = get_node("/root/Node2D/player")
	enemiesScript.loser.connect(loseState)
	ship.lifeCounterUpdate.connect(lifecount)
	pass


func onDeath():
	node.stream = preload("res://audio/explosion.wav")
	node.play()
	global.deaths += 1
	score += 100
	scoreText.text = "SCORE: " + str(score)
	if global.deaths%10 == 0:
		node2.stream = preload("res://audio/chimep.wav")
		node2.play()
		await get_tree().create_timer(1).timeout
		respawn.emit()

func loseState():
	ship.onPlayerDeath()

func lifecount():
	livesText.text = "LIVES: " + str(global.lives)
	respawning = true
	global.deaths = 0
	if global.lives <= 0:
		waveText.text = "GAME OVER"
		node2.stream = preload("res://audio/gameover.wav")
		node2.play()
		return
	elif global.lives > 0:
		node2.stream = preload("res://audio/badchime.wav")
		node2.play()
		await get_tree().create_timer(.3).timeout
		respawn.emit()

func waveUpdate():
	if global.bonusCounter == 2:
		waveText.text = "BONUS"
		bonus()
		global.bonusCounter = 0
	else:
		waveText.text = "WAVE: " + str(global.wave)

func bonus():
	killStars.emit()
	shipBonus.emit()
	spawnAsteroids.emit()

func goodEndBonus(motherShipPosition):
	node2.stream = preload("res://audio/chimep.wav")
	node2.play()
	stopAsteroids.emit()
	score += 500
	scoreText.text = "SCORE: " + str(score)
	ship.canMove = false
	ship.position.x = motherShipPosition
	ship.position.y = 230
	await get_tree().create_timer(.3).timeout
	endBonus()

func badEndBonus():
	node2.stream = preload("res://audio/badchime.wav")
	node2.play()
	stopAsteroids.emit()
	ship.deathanim()
	endBonus()

func endBonus():
	if ship.bonus:
		await get_tree().create_timer(.3).timeout
		exitingBonus = true
		ship.bonus = false
		ship.position.x = ship.screen_width/2
		ship.position.y = 812
		clearBonus.emit()
		waveText.text = "WAVE: " + str(global.wave)
		respawn.emit()
	ship.canMove = true

func _process(delta):
	
	pass
