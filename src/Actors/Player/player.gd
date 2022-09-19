class_name Player
extends Actor

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

var roll_vector = Vector2.RIGHT
var can_roll = true
export var ROLL_TIMEOUT = 0.5
export var INVINCIBLE_TIME = 0.5

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hit_box = $HitBoxPivot/SwordHitBox
onready var hurt_box = $HurtBox
const hurtSound = preload("res://src/Actors/Player/PlayerHurtSound.tscn")

signal pause_instance

func _ready():
	PlayerStats.connect("no_health", self, "queue_free")
	animation_tree.active = true
	sword_hit_box.knockback_vector = roll_vector
	$HitBoxPivot/SwordHitBox/CollisionShape2D.disabled = true

func _physics_process(delta):
	match state:
		MOVE:
			$HitBoxPivot/SwordHitBox/CollisionShape2D.disabled = true
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			$HitBoxPivot/SwordHitBox/CollisionShape2D.disabled = true
			if can_roll:
				roll_state(delta)
			else:
				state = MOVE
	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_vector.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hit_box.knockback_vector = roll_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animation_state.travel("Idle")
	velocity = move(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state(_delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	
func roll_animation_finished():
	velocity = velocity / 4
	$HurtBox/CollisionShape2D.disabled = false
	state = MOVE
	can_roll = false
	$RollTimer.start(ROLL_TIMEOUT)
	
func attack_animation_finished():
	state = MOVE
	$HitBoxPivot/SwordHitBox/CollisionShape2D.disabled = true
	
func roll_state(_delta):
	$HurtBox/CollisionShape2D.disabled = true
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	move(velocity)
	
func move(velocity):
	return move_and_slide(velocity) 

func _on_HurtBox_area_entered(area):
	if !hurt_box.invincible:
		PlayerStats.health -= area.damage
	hurt_box.start_invincible(INVINCIBLE_TIME)
	hurt_box.create_hit_effect()
	modulate.a = 0.6
	get_tree().current_scene.add_child(hurtSound.instance())

func _on_HurtBox_invincibility_ended():
	modulate.a = 1

func _on_RollTimer_timeout():
	can_roll = true
