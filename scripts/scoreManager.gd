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
signal espawn

var exitingBonus = false
var titlePic
var titleText
var inplay = false
var hiscore = 0
var hiscoreText
# Called when the node enters the scene tree for the first time.
func _ready():
	respawning = false
	add_child(node)
	add_child(node2)
	scoreText = get_node("/root/Node2D/interface/Label")
	livesText = get_node("/root/Node2D/interface/Label2")
	waveText = get_node("/root/Node2D/interface/Label3")
	hitPercentText = get_node("/root/Node2D/interface/Label4")
	titleText = get_node("/root/Node2D/interface/Label5")
	hiscoreText = get_node("/root/Node2D/interface/Label6")
	enemiesScript = get_node("/root/Node2D/enemies")
	ship = get_node("/root/Node2D/player")
	titlePic = get_node("/root/Node2D/interface/TextureRect")
	enemiesScript.loser.connect(loseState)
	ship.lifeCounterUpdate.connect(lifecount)
	titleScreen()
	

func titleScreen():
	if score > hiscore:
		hiscore = score
	hiscoreText.text = "HI SCORE: " + str(hiscore)
	score = 0
	scoreText.text = ""
	livesText.text = ""
	waveText.text = ""
	killStars.emit()
	titlePic.visible = true
	titleText.text = "SPACE TO START"
	ship.visible = false
	inplay = false

func _input(event):
	if event.is_action_pressed("shoot"):
		startGame()

func startGame():
	if !inplay:
		hiscoreText.text = ""
		respawning = false
		global.lives = 3
		global.deaths = 0
		global.wave = 0
		global.bonusCounter = -1
		inplay = true
		titlePic.visible = false
		titleText.text = "" 
		node2.stream = preload("res://audio/chime_c01.wav")
		node2.play()
		spawnStars.emit()
		livesText.text = "LIVES: " + str(global.lives)
		scoreText.text = "SCORE: " + str(score) 
		espawn.emit()
		ship.visible = true
		ship.canMove = true
		ship.canShoot = true

func onDeath():
	node.stream = preload("res://audio/explosion.wav")
	node.play()
	global.deaths += 1
	score += 100
	scoreUpdater()
	if global.deaths%10 == 0:
		node2.stream = preload("res://audio/chime_c01.wav")
		node2.play()
		await get_tree().create_timer(1).timeout
		respawn.emit()

func scoreUpdater():
	scoreText.text = "SCORE: " + str(score)
	if score%5000 == 0:
		oneup()

func oneup():
	node2.stream = preload("res://audio/chime_c03.wav")
	node2.play()
	global.lives += 1
	livesText.text = "LIVES: " + str(global.lives)

func loseState():
	ship.onPlayerDeath() 

func lifecount():
	livesText.text = "LIVES: " + str(global.lives)
	respawning = true
	global.deaths = 0
	if global.lives <= 0:
		waveText.text = "GAME OVER"
		node2.stream = preload("res://audio/gameover.wav")
		ship.canMove = false
		ship.canShoot = false
		node2.play()
		await get_tree().create_timer(4).timeout
		titleScreen()
		return
	elif global.lives > 0:
		node2.stream = preload("res://audio/chime_c02.wav")
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
	shipBonus.emit()
	spawnAsteroids.emit()
	hitPercentText.text = "DOCK SHIP!"
	await get_tree().create_timer(1).timeout
	hitPercentText.text = ""

func goodEndBonus(motherShipPosition):
	node2.stream = preload("res://audio/chime_c01.wav")
	node2.play()
	stopAsteroids.emit()
	for i in 5:
		score += 100
		scoreUpdater()
	ship.canMove = false
	ship.position.x = motherShipPosition
	ship.position.y = 230
	await get_tree().create_timer(.3).timeout
	endBonus()

func badEndBonus():
	node2.stream = preload("res://audio/chime_c02.wav")
	node2.play()
	stopAsteroids.emit()
	ship.deathanim()
	endBonus()
	await get_tree().create_timer(1).timeout
	ship.flewout = false

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
