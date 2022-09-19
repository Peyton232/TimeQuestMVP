extends Node2D


export(float) var playerX = 200
export(float) var playerY = 100

onready var player = $Enities/Player

func _ready():
	player.global_position.x = playerX
	player.global_position.y = playerY

