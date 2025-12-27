extends Node
class_name HealthComponent

signal defeat
signal healthChanged

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
	
func TakeDamage(damage: float) -> void:
	health -= damage
