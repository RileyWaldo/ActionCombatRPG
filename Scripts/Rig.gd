extends Node3D
class_name Rig

signal heavyAttack

@export var animationSpeed := 10.0

const runPath: String = "parameters/MoveSpace/blend_position"
const playBackPath: String = "parameters/playback"
const MOVESPACE: String = "MoveSpace"
const SLASH: String = "Slash"
const OVERHEAD: String = "Overhead"
const OVERHEADSTATES: Array[String] = [OVERHEAD, "OverheadRecover"]
const DASH: String = "Dash"

var runWeightTarget := -1.0

@onready var animationTree: AnimationTree = $AnimationTree
@onready var playBack: AnimationNodeStateMachinePlayback = animationTree[playBackPath]
@onready var skeleton: Skeleton3D = $CharacterRig/GameRig/Skeleton3D
@onready var weaponSlot: Node3D = %WeaponSlot
@onready var shieldSlot: Node3D = %ShieldSlot

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
	return playBack.get_current_node() == MOVESPACE
	
func IsSlashing() -> bool:
	return playBack.get_current_node() == SLASH
	
func IsOverhead() -> bool:
	return playBack.get_current_node() in OVERHEADSTATES
	
func IsDashing() -> bool:
	return playBack.get_current_node() == DASH
	
func SetRigCharacterMesh(mesh: Node3D) -> void:
	for child in skeleton.get_children():
		child.visible = false
		
	mesh.visible = true
	
func ReplaceShield(shieldScene: PackedScene) -> void:
	for child in shieldSlot.get_children():
		child.queue_free()
		
	var newShield := shieldScene.instantiate()
	shieldSlot.add_child(newShield)
	
func ReplaceWeapon(weaponScene: PackedScene) -> void:
	for child in weaponSlot.get_children():
		child.queue_free()
		
	var newWeapon := weaponScene.instantiate()
	weaponSlot.add_child(newWeapon)

func _on_animation_tree_animation_finished(animName: StringName) -> void:
	if(animName == OVERHEAD):
		heavyAttack.emit()
