class_name Actor
extends KinematicBody2D

# Both the Player and Enemy inherit this scene as they have shared behaviours
# such as speed and are affected by gravity.
export var FRICTION = 400

export var speed = Vector2(100, 100)
export var ACCELERATION = 400
export var MAX_SPEED = 100
export var ROLL_SPEED = 140
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

const FLOOR_NORMAL = Vector2.UP

var velocity = Vector2.ZERO
