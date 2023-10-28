extends Area2D
var screen_width = 0
var speed = randi_range(230,305)+(global.wave*10)
var canMove = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = get_viewport().get_visible_rect().size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canMove:
		move_local_x(speed*delta)
	if self.position.x > screen_width + 40:
		self.position.x = -40

func pause():
	canMove = false

func cleanup():
	queue_free()

func _on_body_entered(body):
	ScoreManager.badEndBonus()
