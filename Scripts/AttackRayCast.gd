extends RayCast3D

func DealDamage(damage: float, critChance: float) -> void:
	if(!is_colliding()):
		return
		
	var collider = get_collider()
	if(collider is Enemy):
		add_exception(collider)
		var isCrit = randf() <= critChance
		collider.healthComponent.TakeDamage(damage, isCrit)
