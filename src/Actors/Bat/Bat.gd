class_name Bat
extends Actor

var knockback = Vector2.ZERO

export(float) var WANDER_PADDING = 4

onready var stats = $Stats
onready var sprite = $Sprite
onready var wanderController = $WanderController

const DeathEffect = preload("res://src/Actors/DeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	MAX_SPEED = 40
	sprite.frame = rand_range(0, 4)
	new_wander()


var player = null
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION / 2 * delta )
	knockback = move_and_slide(knockback)
	
	if $PlayerDetectionZone.can_see_player():
		player = $PlayerDetectionZone.player
		state = CHASE
	else:
		randomize()
		if state == CHASE:
			state = WANDER
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				new_wander()
		WANDER:
			velocity = move(wanderController.target_position, delta)
			if wanderController.get_time_left() == 0:
				new_wander()
			if global_position.distance_to(wanderController.target_position) <= WANDER_PADDING:
				new_wander()
		CHASE:
			velocity = move(player.global_position, delta)
	velocity = move_and_slide(velocity)

func move(location, delta):
	var direction = global_position.direction_to(location)
	sprite.flip_h = velocity.x < 0
	return velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
func new_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	$HurtBox.create_hit_effect()
	knockback = area.knockback_vector * 140


func create_death_effect():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position

func _on_Stats_no_health():
	create_death_effect()
	queue_free()
