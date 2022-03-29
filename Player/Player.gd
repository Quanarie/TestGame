extends KinematicBody2D

export var gravity = 1000
export var acceleration = 1000
export var max_speed = 200
export var jump_force = 400
export var jump_decrease_on_release_coefficient = 2
export var slowdown_coefficient_ground = 0.5
export var slowdown_coefficient_air = 0.05

var velocity = Vector2.ZERO

onready var animatedSprite = $AnimatedSprite

func _physics_process(delta):
	velocity.y += gravity * delta
	
	var apply_friction = false
	
	if Input.is_action_pressed("ui_right"):
		if velocity.x < 0:
			velocity.x *= (1 - slowdown_coefficient_ground)   #helps to change direction faster
		velocity.x = min(velocity.x + acceleration * delta, max_speed)
		animatedSprite.flip_h = false
		if is_on_floor():
			animatedSprite.play("Run")
	elif Input.is_action_pressed("ui_left"):
		if velocity.x > 0:
			velocity.x *= (1 - slowdown_coefficient_ground)
		velocity.x = max(velocity.x - acceleration * delta, -max_speed)
		animatedSprite.flip_h = true
		if is_on_floor():
			animatedSprite.play("Run")
	else:
		apply_friction = true
		if is_on_floor():
			animatedSprite.play("Idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y -= jump_force
		if apply_friction:
			velocity.x = lerp(velocity.x, 0, slowdown_coefficient_ground)
	elif Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= jump_decrease_on_release_coefficient
		
	if not is_on_floor():
		animatedSprite.play("Jump")
		if apply_friction:
			velocity.x = lerp(velocity.x, 0, slowdown_coefficient_air)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("attack"):
		animatedSprite.play("Attack")
