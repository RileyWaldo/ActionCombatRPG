extends Node
class_name HealthComponent

signal defeat
signal healthChanged

@export var body: PhysicsBody3D

var maxHealth: float
var health: float:
	set(value):
		health = max(0.0, value)
		if(health <= 0.0):
			defeat.emit()
		healthChanged.emit()

func UpdateMaxHealth(maxHp: float) -> void:
	maxHealth = maxHp
	health = maxHealth
	
func GetHealthString() -> String:
	return "%s/%s" % [int(health), int(maxHealth)]
	
func TakeDamage(damage: float, isCrit: bool) -> void:
	var color := Color.WHITE
	if(isCrit):
		color = Color.RED
		damage *= 2
	health -= damage
	VfxManager.SpawnDamageNumber(damage, color, body.global_position)
	
func IsDead() -> bool:
	return is_zero_approx(health)
