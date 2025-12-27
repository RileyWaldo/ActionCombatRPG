extends RayCast3D

func DealDamage() -> void:
	if(!is_colliding()):
		return
		
	var collider = get_collider()
	print(collider)
	add_exception(collider)
