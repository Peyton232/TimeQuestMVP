extends Node2D


export(float) var playerX = 200
export(float) var playerY = 100
export(bool) var paused = false

onready var player = $Enities/Player

func _ready():
	player.global_position.x = playerX
	player.global_position.y = playerY

func _process(delta):
	if Input.is_action_just_pressed("time_change"):
		switch_Scene()
		
		
func switch_Scene():
	get_tree().change_scene("res://src/Levels/Levl1B.tscn")
