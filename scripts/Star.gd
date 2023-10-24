extends Sprite2D
var screen_height = 0
var screen_width = 0
var speed = 150
var canMove = true
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_height = get_viewport().get_visible_rect().size.y
	screen_width = get_viewport().get_visible_rect().size.x
	self.position.y = randi_range(0, screen_height)
	self.position.x = randi_range(0, screen_width)
	speed = randi_range(150,225)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canMove == true:
		move_local_y(speed*delta)
		if self.position.y > screen_height + 40:
			self.position.x = randi_range(0, screen_width)
			self.position.y = -40
			speed = randi_range(150,225)


func stop():
	pass

func die():
	queue_free()
