extends Node3D

@onready var label: Label3D = $Label3D

func SetUp(damage: int, color: Color, positionIn: Vector3) -> void:
	if(!is_inside_tree()):
		await ready
	label.text = str(damage)
	label.modulate = color
	global_position = positionIn
