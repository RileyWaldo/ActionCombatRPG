extends RayCast3D

func DealDamage() -> void:
	if(!is_colliding()):
		return
		
	var collider = get_collider()
	if(collider is Enemy):
		add_exception(collider)
		collider.healthComponent.TakeDamage(15.0)
