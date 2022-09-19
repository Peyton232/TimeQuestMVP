extends Node2D

export(int) var wander_range = 32

onready var start_position = global_position
onready var target_position = global_position
onready var timer = $Timer

func update_target_position():
	randomize()
	var rand_x = rand_range(-wander_range, wander_range)
	var rand_y = rand_range(-wander_range, wander_range)
	var target_vector = Vector2(rand_x, rand_y)
	target_position = start_position + target_vector

func _on_Timer_timeout():
	update_target_position()

func get_time_left():
	return timer.get_time_left()
	
func start_timer(customDuration):
	timer.start(customDuration)
