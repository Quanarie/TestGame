extends Node

export var max_health = 1 setget set_max_health
var health = 1 setget set_health

func set_health(value):
	health = value
	
func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	
func _ready():
	self.health = max_health
