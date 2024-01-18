extends CharacterBody2D


const SPEED = 75.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 600
const FRICTION = 1000
var JUMP_CHARGE = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("left", "right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	move_and_slide()
	

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if is_on_floor():   
		if Input.is_action_just_pressed("jump"):
			$charge_1_to_2.start()
			
		if Input.is_action_just_released("jump"):
			handle_jump_height()
			JUMP_CHARGE = 1
			$AnimatedSprite2D.play("jump")
			$AnimatedSprite2D.play("walk")
	else:
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
	match JUMP_CHARGE:
		1:
			velocity.y = JUMP_VELOCITY / 4
		2:
			velocity.y = JUMP_VELOCITY / 2
		3:
			velocity.y = JUMP_VELOCITY

func _on_charge_1_to_2_timeout():
	$AnimatedSprite2D.play("charge_jump_2")
	JUMP_CHARGE = 2
	$charge_2_to_3.start()
	


func _on_charge_2_to_3_timeout():
	$AnimatedSprite2D.play("charge_jump_3")
	JUMP_CHARGE = 3
