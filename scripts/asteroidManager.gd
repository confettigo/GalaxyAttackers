extends Node2D
@export var astScene:PackedScene
@export var mothershipScene:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreManager.spawnAsteroids.connect(spawn)
	ScoreManager.stopAsteroids.connect(pause)
	ScoreManager.clearBonus.connect(cleanup)

func pause():
	for asteroid in get_children():
		asteroid.pause()
func cleanup():
	for asteroid in get_children():
		asteroid.cleanup()

func spawn():
	var mothership = mothershipScene.instantiate()
	call_deferred("add_child", mothership)
	mothership.position.x = 324
	mothership.position.y = 175
	for i in 5:
		var asteroid = astScene.instantiate()
		call_deferred("add_child",asteroid)
		asteroid.position.x = randi_range(40, 608)
		asteroid.position.y = 300 + i*100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
