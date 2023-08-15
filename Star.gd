extends Sprite2D
var screen_height = 0
var speed = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_height = get_viewport().get_visible_rect().size.y
	self.position.y = randi_range(0, screen_height)
	self.position.x = randi_range(0, 648)
	speed = randi_range(150,225)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_y(speed*delta)
	if self.position.y > screen_height + 40:
		self.position.x = randi_range(0, 648)
		self.position.y = -40
		speed = randi_range(150,225)
	pass
