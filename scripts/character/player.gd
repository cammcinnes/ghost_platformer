extends CharacterBody2D


const SPEED = 75.0
const HORZ_JUMP_VELOCITY = 150
const JUMP_VELOCITY = -300.0
const ACCELERATION = 600
const FRICTION = 1000
var JUMP_TIMER = 1
var chargeJump = false
var direction = 0
var jumping = false
var movedWhileJumpCharge = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	if not jumping:
		var input_axis = Input.get_axis("left", "right")
		get_if_player_moved()
		handle_acceleration(input_axis, delta)
		apply_friction(input_axis, delta)
	move_and_slide()
	handle_direction_animation()
	

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if is_on_floor():
		jumping = false   
		if Input.is_action_just_pressed("jump"):
			movedWhileJumpCharge = false
			if not chargeJump:
				$jump2.start()
				$jump3.start()
				chargeJump = true
		
		if Input.is_action_just_released("jump") and chargeJump:
			handle_jump_height()
			$AnimatedSprite2D.play("jump")
			$AnimatedSprite2D.play("walk")
			$jump2.stop()
			$jump3.stop()
			JUMP_TIMER = 1
			chargeJump = false
		if movedWhileJumpCharge:
			$jump2.stop()
			$jump3.stop()
			chargeJump = false
			movedWhileJumpCharge = false
	else:
		jumping = true
		if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
			
func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
func handle_acceleration(input_axis, delta):
	if input_axis:
		$AnimatedSprite2D.play("walk")
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)

func handle_jump_height():
	if JUMP_TIMER == 1:
		velocity.y = JUMP_VELOCITY / 2
		velocity.x = direction * HORZ_JUMP_VELOCITY / 3
	elif JUMP_TIMER == 2:
		velocity.y = JUMP_VELOCITY / 1.5
		velocity.x = direction * HORZ_JUMP_VELOCITY * 2/3
	elif JUMP_TIMER == 3:
		velocity.y = JUMP_VELOCITY
		velocity.x = direction * HORZ_JUMP_VELOCITY


func _on_jump_2_timeout():
	JUMP_TIMER = 2
	$AnimatedSprite2D.play("charge_jump_2")
	$jump2.stop()


func _on_jump_3_timeout():
	JUMP_TIMER = 3
	$AnimatedSprite2D.play("charge_jump_3")
	$jump3.stop()
	
func handle_direction_animation():
	if velocity.x > 0:
		direction = 1
	if velocity.x < 0:
		direction = -1
	if velocity.x > 0 or velocity.x < 0:
		$AnimatedSprite2D.flip_h = direction > 0

func get_if_player_moved():
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		movedWhileJumpCharge = true 
