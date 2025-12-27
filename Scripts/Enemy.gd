extends CharacterBody3D
class_name Enemy

@export var maxHealth := 20.0

@onready var healthComponent: HealthComponent = $HealthComponent
@onready var rig: Rig = $Rig
@onready var meshes: Array[Node3D] = [
	$Rig/CharacterRig/GameRig/Skeleton3D/Villager_01,
	$Rig/CharacterRig/GameRig/Skeleton3D/Villager_02
]

func _ready() -> void:
	rig.SetRigCharacterMesh(meshes.pick_random())
	healthComponent.UpdateMaxHealth(maxHealth)


func OnDefeat() -> void:
	rig.Travel("Defeat")
