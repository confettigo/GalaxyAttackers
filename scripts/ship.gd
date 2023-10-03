extends CharacterBody2D


const SPEED = 300.0
@export var animatedSprite:AnimatedSprite2D
@export var missile:Resource
@export var projectiles:NodePath
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_width = 0
var instance
signal lifeCounterUpdate
var sound
var canShoot = true

func _ready():
	animatedSprite.play("alive")
	screen_width = get_viewport().get_visible_rect().size.x
	instance = missile.instantiate()
	var node = get_node(projectiles)
	node.add_child.call_deferred(instance)
	instance.position.x = -100
	instance.hide()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if !direction:
		return
	if self.position.x > 40 && direction < 0 || self.position.x < screen_width - 40 && direction > 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):
		_shoot()

func _shoot():
	if canShoot:
		if sound != "shoot":
			$AudioStreamPlayer2D.stream = preload("res://audio/shot.wav")
			sound = "shoot"
		$AudioStreamPlayer2D.play()
		instance.isEnabled = true
		instance.position = self.position
		instance.position.y -= 10
		instance.show()

func onPlayerDeath():
	if ScoreManager.hasLost == true:
		canShoot = false
		$AudioStreamPlayer2D.stream = preload("res://audio/explosion.wav")
		sound = "explosion"
		$AudioStreamPlayer2D.play()
		animatedSprite.play("death", 4)
		await get_tree().create_timer(1).timeout
		global.lives -= 1
		print(global.lives)
		lifeCounterUpdate.emit()
	#add shit to show the player dying and all that

func _on_enemy_body_entered(body):
	pass # Replace with function body.


func _on_sprite_2d_animation_finished():
	self.visible = false
	await get_tree().create_timer(.5).timeout
	animatedSprite.play("alive")
	self.visible = true
	canShoot = true
