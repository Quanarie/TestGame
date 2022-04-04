extends KinematicBody2D

export var FRICTION = 0.2

var knockback = 0

func _physics_process(delta):
	knockback = lerp(knockback, 0, FRICTION)
	move_and_slide(Vector2(knockback, 0))
	
func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_direction
