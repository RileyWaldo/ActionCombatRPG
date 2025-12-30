extends CharacterBody3D
class_name Enemy

@export var maxHealth := 20.0
@export var moveSpeed := 5.0
@export var xpGain := 20
@export var critRate := 0.05

@onready var healthComponent: HealthComponent = $HealthComponent
@onready var navigationAgent: NavigationAgent3D = $NavigationAgent3D
@onready var rig: Rig = $Rig
@onready var collisionShape: CollisionShape3D = $CollisionShape3D
@onready var playerDetector: ShapeCast3D = $Rig/PlayerDetector
@onready var areaAttack: AreaAttack = $Rig/AreaAttack
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var meshes: Array[Node3D] = [
	$Rig/CharacterRig/GameRig/Skeleton3D/Villager_01,
	$Rig/CharacterRig/GameRig/Skeleton3D/Villager_02
]

const RUN_VELOCITY_THRESHOLD: float = 2.0

var velocityTarget := Vector3.ZERO

func _ready() -> void:
	rig.SetRigCharacterMesh(meshes.pick_random())
	healthComponent.UpdateMaxHealth(maxHealth)
	

func _physics_process(delta: float) -> void:
	navigationAgent.target_position = player.global_position
	
	if(is_on_floor()):
		velocityTarget = Vector3.ZERO
		if(rig.IsIdle()):
			CheckForAttacks()
			if(!navigationAgent.is_target_reached()):
				velocityTarget = GetLocalNavDirection() * moveSpeed
				OrientRig(navigationAgent.get_next_path_position())
	else:
		velocityTarget.y += get_gravity().y * delta
	
	navigationAgent.velocity = velocityTarget
	

func CheckForAttacks() -> void:
	for collision in playerDetector.get_collision_count():
		var collider = playerDetector.get_collider(collision)
		if(collider is Player):
			rig.Travel("Overhead")
			navigationAgent.avoidance_mask = 0

func OrientRig(targetPosition: Vector3) -> void:
	targetPosition.y = rig.global_position.y
	if(rig.global_position.is_equal_approx(targetPosition)):
		return
		
	rig.look_at(targetPosition, Vector3.UP, true)

func GetLocalNavDirection() -> Vector3:
	var destination = navigationAgent.get_next_path_position()
	var localDestination = destination - global_position
	return localDestination.normalized()

func OnDefeat() -> void:
	player.stats.xp += xpGain
	rig.Travel("Defeat")
	collisionShape.disabled = true
	set_physics_process(false)


func OnHeavyAttack() -> void:
	areaAttack.DealDamage(20.0, critRate)
	navigationAgent.avoidance_mask = 1


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if(safe_velocity.length() > RUN_VELOCITY_THRESHOLD):
		rig.runWeightTarget = 1.0
	else:
		rig.runWeightTarget = 0.0
	velocity = safe_velocity
	move_and_slide()
