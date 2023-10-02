extends Node2D
@export var enemyTemplate:PackedScene
var enemyList

# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreManager.respawn.connect(spawn)
	spawn()

func spawn():
	global.deaths = 0
	global.wave += 1
	for b in 2:
		for i in 5:
			var enemy = enemyTemplate.instantiate()
			add_child(enemy)
			enemy.position.x = 121.27 + i*100
			enemy.position.y = 181.824 + b*100
	enemyList = get_children()

func changeDirections(direction):
	for enemy in get_children():
		enemy.changeDirection(direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
