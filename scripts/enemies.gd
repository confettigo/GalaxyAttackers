extends Node2D
@export var enemyTemplate:PackedScene
var enemyList
signal loser

# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreManager.respawn.connect(spawn)
	ScoreManager.espawn.connect(spawn)

func spawn():
	global.deaths = 0
	if ScoreManager.respawning == false:
		if !ScoreManager.exitingBonus:
			global.wave += 1
			global.bonusCounter += 1
			ScoreManager.waveUpdate()
			if global.bonusCounter == 0 && global.wave != 1:
				return
	for b in 2:
		for i in 5:
			var enemy = enemyTemplate.instantiate()
			call_deferred("add_child",enemy)
			enemy.position.x = 121.27 + i*100
			enemy.position.y = 181.824 + b*100
			enemy.lose.connect(lose)
	enemyList = get_children()
	ScoreManager.respawning = false
	ScoreManager.hasLost = false
	ScoreManager.exitingBonus = false

func changeDirections(direction):
	for enemy in get_children():
		enemy.changeDirection(direction)

func lose():
	for enemy in get_children():
		enemy.position.y -= 900
		enemy.clearOut()
	loser.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
