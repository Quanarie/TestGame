extends Area2D

export var damage = 1
export var knockback_force = 100

var knockback_direction = 0 setget set_knockback_vector

func set_knockback_vector(value):
	knockback_direction = value * knockback_force
