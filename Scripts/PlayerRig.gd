extends Node3D
class_name PlayerRig

@export var animationSpeed := 10.0

const runPath: String = "parameters/MoveSpace/blend_position"
const playBackPath: String = "parameters/playback"
const moveSpace: String = "MoveSpace"

var runWeightTarget := -1.0

@onready var animationTree: AnimationTree = $AnimationTree
@onready var playBack: AnimationNodeStateMachinePlayback = animationTree[playBackPath]

func _physics_process(delta: float) -> void:
	animationTree[runPath] = move_toward(animationTree[runPath], runWeightTarget, delta * animationSpeed)

func UpdateAnimationTree(direction: Vector3) -> void:
	if(direction.is_zero_approx()):
		runWeightTarget = -1.0
	else:
		runWeightTarget = 1.0
		
func Travel(animationName: String) -> void:
	playBack.travel(animationName)
	
func IsIdle() -> bool:
	return playBack.get_current_node() == moveSpace
