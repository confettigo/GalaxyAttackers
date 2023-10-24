extends Area2D
var canMove = true
var speed = 100
var direction = 0
var screen_width = 0
var docked = false
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = randi_range(1, 2)
	if direction % 2 == 0:
		direction = -1
	else:
		direction = 1
	screen_width = get_viewport().get_visible_rect().size.x

func pause():
	canMove = false
	pass

func cleanup():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canMove:
		move_local_x(direction*speed*delta)
		if self.position.x >= screen_width - 80 || self.position.x <= 80:
			direction *= -1


func _on_body_entered(body):
	if !docked:
		ScoreManager.goodEndBonus(self.position.x)
		docked = true

