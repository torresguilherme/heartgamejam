extends KinematicBody2D

# stats
var hp
var oxygen
var maxHp = 50
var maxOxygen = 60
var speed = 450
var jumpForce = 500
var gravityScale = 1200
var gravityMax = 600
var gravityScaleUnderwater = 800
var swimUpSpeed = 500

# movement
var onGround = false
var underWater = false
var left = 0
var right = 0
var up = 0
var yVelocity = 0

# playab
var invulnerableTime = 1.0
var invulnerable = 0
var canMove = true

enum animDirection {LEFT, RIGHT}
enum animMode {IDLE, WALK, JUMP, FALL}
var currentDirection = RIGHT
var currentMode = IDLE

var bubbles = preload("res://nodes/aux/bubbles.tscn")

func _ready():
	# if: primeiro level
	# else: pegar o valor do ultimo status
	hp = maxHp
	oxygen = maxOxygen
	add_to_group(global.PLAYER_GROUP)

func _process(delta):
	if Input.is_action_pressed("walkLeft") && canMove:
		left = 1
		currentDirection = LEFT
		currentMode = WALK
	else:
		left = 0
	if Input.is_action_pressed("walkRight") && canMove:
		right = 1
		currentDirection = RIGHT
		currentMode = WALK
	else:
		right = 0
	
	if (right - left) == 0:
		currentMode = IDLE
	
	if Input.is_action_just_pressed("walkUp") && canMove:
		if (onGround):
			yVelocity = -jumpForce
		if(underWater):
			yVelocity = -swimUpSpeed
			var newBubbles = bubbles.instance()
			newBubbles.global_position = $feet.position
			add_child(newBubbles)
			oxygen -= 3
	
	if (!onGround):
		if !underWater:
			yVelocity += gravityScale * delta
		else:
			yVelocity += gravityScaleUnderwater * delta
		if yVelocity > gravityMax:
			yVelocity = gravityMax
		if (yVelocity > 0):
			currentMode = FALL
		else:
			currentMode = JUMP
	
	move_and_collide(Vector2(speed * delta * (right - left), 0.0))
	move_and_collide(Vector2(0.0, yVelocity * delta))
	
	#######################################
	### ANIMATION UPDATER #################
	#######################################
	
	if currentDirection == LEFT:
		if currentMode == IDLE:
			if $anim.current_animation != "idle-left":
				$anim.play("idle-left")
		elif currentMode == WALK:
			if $anim.current_animation != "walk-left":
				$anim.play("walk-left")
		elif currentMode == JUMP:
			if $anim.current_animation != "jump-left":
				$anim.play("jump-left")
		elif currentMode == FALL:
			if $anim.current_animation != "fall-left":
				$anim.play("fall-left")
	if currentDirection == RIGHT:
		if currentMode == IDLE:
			if $anim.current_animation != "idle-right":
				$anim.play("idle-right")
		elif currentMode == WALK:
			if $anim.current_animation != "walk-right":
				$anim.play("walk-right")
		elif currentMode == JUMP:
			if $anim.current_animation != "jump-right":
				$anim.play("jump-right")
		elif currentMode == FALL:
			if $anim.current_animation != "fall-right":
				$anim.play("fall-right")
	
	################################
	### OTHER UPDATES ##############
	################################
	if invulnerable > 0:
		invulnerable -= delta
	
	if underWater:
		$breath.emitting = true
		if oxygen > 0:
			oxygen -= delta
		else:
			takeDamage(10)
	else:
		oxygen = maxOxygen
		$breath.emitting = false
	if oxygen < 0:
		oxygen = 0

func takeDamage(value):
	if invulnerable <= 0:
		hp -= value
		oxygen -= 2 * value
		invulnerable = invulnerableTime
		if hp > 0:
			$"damage-anim".play("damage")
			$"sfx-damage".play()
		else:
			$"../anim".play("gameOver")