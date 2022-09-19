extends Node2D

const Level1A = preload("res://src/Levels/Level1A.tscn")
const Level1B = preload("res://src/Levels/Levl1B.tscn")

export(float) var playerX = 200
export(float) var playerY = 100
export(int) var currentStage = 0

enum {
	stageA,
	stageB
}
enum {
	FRONT,
	BACK
}
var nodeA
var nodeB

func _ready():
	if currentStage == stageA:
		instance_side_A()
	elif currentStage == stageB:
		instance_side_B()
	#set_pause_scene(nodeB, false)

func _process(delta):
	if Input.is_action_just_pressed("time_change"):
		if currentStage == stageA:
			nuke_side_A()
		elif currentStage == stageB:
			nuke_side_B()

func instance_side_A():
	nodeA = Level1A.instance()
	nodeA.playerX = playerX
	nodeA.playerY = playerY
	self.add_child(nodeA)
	nodeA.global_position = global_position
	
func instance_side_B():
	nodeB = Level1B.instance()
	nodeB.playerX = playerX
	nodeB.playerY = playerY
	self.add_child(nodeB)
	nodeB.global_position = global_position
	
func nuke_side_A():
	get_tree().change_scene("res://src/Levels/Levl1B.tscn")
	
func nuke_side_B():
	get_tree().change_scene("res://src/Levels/Levl1A.tscn")

func switch_to_side_A():
	currentStage = stageA
	set_pause_scene(nodeA, true)
	set_pause_scene(nodeB, false)
	move_child(nodeA, FRONT)
	move_child(nodeB, BACK)
	nodeA.playerX = playerX
	nodeA.playerY = playerY
	
func switch_to_side_B():
	currentStage = stageB
	set_pause_scene(nodeB, true)
	set_pause_scene(nodeA, false)
	move_child(nodeB, FRONT)
	move_child(nodeA, BACK)
	nodeB.playerX = playerX
	nodeB.playerY = playerY

func execute_order66(node):
	if node != null:
		node.queue_free()

##### UTILITY
#(Un)pauses a single node
func set_pause_node(node : Node, pause : bool) -> void:
	node.set_process(!pause)
	node.set_process_input(!pause)
	node.set_process_internal(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)

#(Un)pauses a scene
#Ignored childs is an optional argument, that contains the path of nodes whose state must not be altered by the function
func set_pause_scene(rootNode : Node, pause : bool, ignoredChilds : PoolStringArray = [null]):
	set_pause_node(rootNode, pause)
	for node in rootNode.get_children():
		if not (String(node.get_path()) in ignoredChilds):
			set_pause_scene(node, pause, ignoredChilds)
