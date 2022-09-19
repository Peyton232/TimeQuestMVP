extends Control

onready var heartUI = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

var hearts = 8 setget set_hearts
var max_hearts = 8 setget set_max_hearts

# this is a bandaid on a bug
func no_hearts():
	hearts = 0
	if heartUI != null:
		heartUI.rect_size.x = hearts * 7.5

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUI != null:
		heartUI.rect_size.x = hearts * 7.5

func set_max_hearts(value):
	max_hearts = max(value, 1)
	hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = 7.5 * max_hearts

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	PlayerStats.connect("no_health", self, "no_hearts")
