extends CharacterBody2D


const SPEED = 300.0
@export var animatedSprite:AnimatedSprite2D
@export var missile:Resource
@export var projectiles:NodePath
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_width = 0
var screen_height = 0
var instance
signal lifeCounterUpdate
var sound
var canShoot = true
var bonus = false
var canMove = true

func _ready():
	animatedSprite.play("alive")
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
	instance = missile.instantiate()
	var node = get_node(projectiles)
	node.add_child.call_deferred(instance)
	instance.position.x = -100
	instance.hide()
	ScoreManager.shipBonus.connect(bonusActivator)

func getInput():
	var input_direction = Input.get_vector("left", "right", "up", "back")
	if self.position.x < 40:
		if input_direction.x < 0:
			input_direction.x = 0
	if self.position.x > screen_width - 45:
		if input_direction.x > 0:
			input_direction.x = 0
	if bonus == false:
		input_direction.y = 0
	if !canMove:
		input_direction.x = 0
		input_direction.y = 0
	if self.position.y > screen_height - 45:
		if input_direction.y > 0:
			input_direction.y = 0
	if self.position.y > 135:
		pass
	velocity = input_direction * SPEED

func _physics_process(delta):
	getInput()
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
		instance.position.x += 1
		instance.position.y -= 4
		instance.show()
		global.shots += 1

func onPlayerDeath():
	if ScoreManager.hasLost == true:
		canShoot = false
		deathanim()
		await get_tree().create_timer(1).timeout
		global.lives -= 1
		print(global.lives)
		lifeCounterUpdate.emit()


func deathanim():
	canMove = false
	$AudioStreamPlayer2D.stream = preload("res://audio/explosion.wav")
	sound = "explosion"
	$AudioStreamPlayer2D.play()
	animatedSprite.play("death", 4)

func bonusActivator():
	bonus = true

func bonusDeath():
	deathanim()

func _on_sprite_2d_animation_finished():
	self.visible = false
	await get_tree().create_timer(.5).timeout
	animatedSprite.play("alive")
	self.visible = true
	canShoot = true
	canMove = true
