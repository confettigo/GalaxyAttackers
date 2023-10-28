extends Node2D
@export var starScene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreManager.killStars.connect(killStars)
	ScoreManager.spawnStars.connect(spawn)
	

func spawn():
	for i in 12:
		var star = starScene.instantiate()
		call_deferred("add_child",star)
		star.position.y = 800

func killStars():
	for star in get_children():
		star.die()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
