extends Area2D
var speed = 50
var screen_width
var multiplier
var direction = 1
var parent
@onready var animatedSprite = $AnimatedSprite2D
signal lose

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	screen_width = get_viewport().get_visible_rect().size.x
	animatedSprite.play("passive", 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	multiplier = (global.deaths/4) + global.wave
	move_local_x(speed*delta*multiplier*direction)
	if self.position.x > screen_width - 40 || self.position.x < 40:
		parent.changeDirections(-direction)
	if self.position.y > 780:
		lose.emit()
	
func changeDirection(change):
	self.position.y += 100
	direction = change
	pass

func _on_area_entered(area):
	if area.is_in_group("missile"):
		death(area)

func death(area):
	ScoreManager.onDeath()
	area.position.x = -100
	animatedSprite.play("deathAnim", 4)
	
func clearOut():
	queue_free()

func _on_animated_sprite_2d_animation_finished():
	queue_free()
