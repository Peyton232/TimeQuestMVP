class_name Effects
extends AnimatedSprite

export var color = Color(1, 1, 1)


func _ready():
	frame = 0
	play("default")
	modulate = color
	var _val = connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished():
	queue_free()
