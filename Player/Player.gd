extends KinematicBody2D

export var gravity = 1000
export var acceleration = 1000
export var max_speed = 200
export var jump_force = 400
export var jump_decrease_on_release_coefficient = 2
export var slowdown_coefficient_ground = 0.5
export var slowdown_coefficient_air = 0.05

var velocity = Vector2.ZERO

onready var sprite = $Sprite
onready var animationTree = $AnimationTree
onready var hitbox = $Hitbox

func _ready():
	animationTree.active = true

func _physics_process(delta):
	velocity.y += gravity * delta
	
	var apply_friction = false
	
	if Input.is_action_pressed("ui_right"):
		animationTree.set("parameters/Movement/current", 1)
		if velocity.x < 0:
			velocity.x *= (1 - slowdown_coefficient_ground)   #helps to change direction faster
		velocity.x = min(velocity.x + acceleration * delta, max_speed)
		sprite.flip_h = false
		hitbox.rotation_degrees = 0
	elif Input.is_action_pressed("ui_left"):
		animationTree.set("parameters/Movement/current", 1)
		if velocity.x > 0:
			velocity.x *= (1 - slowdown_coefficient_ground)
		velocity.x = max(velocity.x - acceleration * delta, -max_speed)
		sprite.flip_h = true
		hitbox.rotation_degrees = 180
	else:
		animationTree.set("parameters/Movement/current", 0)
		apply_friction = true
	
	if is_on_floor():
		animationTree.set("parameters/InAirState/current", 0)
		if Input.is_action_just_pressed("jump"):
			velocity.y -= jump_force
			animationTree.set("parameters/InAir/current", 1)
			animationTree.set("parameters/InAirState/current", 1)
		if apply_friction:
			velocity.x = lerp(velocity.x, 0, slowdown_coefficient_ground)
	else:
		if velocity.y > 0:
			animationTree.set("parameters/InAir/current", 0)
		animationTree.set("parameters/InAirState/current", 1)
		if Input.is_action_just_released("jump"):
			animationTree.set("parameters/InAir/current", 0)
			if velocity.y < 0:
				velocity.y /= jump_decrease_on_release_coefficient
		
	if not is_on_floor() and apply_friction:
		velocity.x = lerp(velocity.x, 0, slowdown_coefficient_air)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("attack"):
		animationTree.set("parameters/Attack/current", 1)
		
func on_attack_animation_ended():
	animationTree.set("parameters/Attack/current", 0)
