extends Area2D

const HitEFfect = preload("res://src/Actors/HitEffect.tscn")

onready var timer = $Timer

export var color = Color(1, 1, 1)

var invincible = false

signal invincibility_started
signal invincibility_ended
		
func start_invincible(duration):
	invincible = true
	emit_signal("invincibility_started")
	timer.start(duration)
		
func _on_Timer_timeout():
	self.invincible = false
	emit_signal("invincibility_ended")

func create_hit_effect():
	var effect = HitEFfect.instance()
	effect.color = color
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_HurtBox_invincibility_started():
	set_deferred("monitoring", false)

func _on_HurtBox_invincibility_ended():
	monitoring = true
