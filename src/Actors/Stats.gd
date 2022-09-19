extends Node


export(int) var max_health = 8 setget set_max_health
var health = max_health setget set_health


signal no_health
signal health_changed
signal max_health_changed

func set_max_health(value):
	max_health = max(1, value)
	health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	var changed = health - value
	health = value
	if health <= 0:
		emit_signal("no_health")
	elif changed:
		emit_signal("health_changed", health)
	
func _ready():
	health = max_health
