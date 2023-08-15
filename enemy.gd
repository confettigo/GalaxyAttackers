extends Area2D
var speed = 50
var screen_width
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	screen_width = get_viewport().get_visible_rect().size.x



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x(speed*delta)
	if self.position.x > screen_width - 40 || self.position.x < 40:
		self.position.y += 100
		speed = -speed
	
