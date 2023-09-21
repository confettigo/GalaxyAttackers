extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_width = 0
var missile = load("res://missile.tscn")
var instance

func _ready():
	screen_width = get_viewport().get_visible_rect().size.x
	instance = missile.instantiate()
	var node = get_tree().root.get_child(0).get_node("projectiles")
	node.add_child.call_deferred(instance)
	instance.position.x = -100
	instance.hide()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if !direction:
		return
	print(direction)
	if self.position.x > 40 && direction < 0 || self.position.x < screen_width - 40 && direction > 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):
		_shoot()

func _shoot():
	$AudioStreamPlayer2D.play()
	instance.position = self.position
	instance.position.y -= 10
	instance.show()


func _on_enemy_body_entered(body):
	pass # Replace with function body.
