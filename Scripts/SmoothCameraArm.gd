extends SpringArm3D

@export var target: Node3D
@export var decay := 20.0

func _physics_process(delta: float) -> void:
	var weight := 1.0 - exp(-decay * delta)
	global_transform = global_transform.interpolate_with(target.global_transform, weight)
