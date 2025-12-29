extends Node3D

const DAMAGE_NUMBER = preload("uid://g4d7xrn3bm16")

func SpawnDamageNumber(damage: float, color: Color, positionIn: Vector3) -> void:
	var newNumber = DAMAGE_NUMBER.instantiate()
	newNumber.SetUp(damage, color, positionIn)
	add_child(newNumber)
