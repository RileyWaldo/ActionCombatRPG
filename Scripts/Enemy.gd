extends CharacterBody3D
class_name Enemy

@export var maxHealth := 20.0

@onready var healthComponent: HealthComponent = $HealthComponent
@onready var rig: Rig = $Rig
@onready var collisionShape: CollisionShape3D = $CollisionShape3D
@onready var playerDetector: ShapeCast3D = $PlayerDetector
@onready var meshes: Array[Node3D] = [
	$Rig/CharacterRig/GameRig/Skeleton3D/Villager_01,
	$Rig/CharacterRig/GameRig/Skeleton3D/Villager_02
]

func _ready() -> void:
	rig.SetRigCharacterMesh(meshes.pick_random())
	healthComponent.UpdateMaxHealth(maxHealth)
	

func _physics_process(delta: float) -> void:
	if(rig.IsIdle()):
		CheckForAttacks()

func CheckForAttacks() -> void:
	for collision in playerDetector.get_collision_count():
		var collider = playerDetector.get_collider(collision)
		print(collider)

func OnDefeat() -> void:
	rig.Travel("Defeat")
	collisionShape.disabled = true
	set_physics_process(false)
