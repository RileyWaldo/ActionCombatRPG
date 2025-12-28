extends ShapeCast3D
class_name AreaAttack

func DealDamage(damage: float) -> void:
	for collision in get_collision_count():
		var collider = get_collider(collision)
		if(collider is Player or collider is Enemy):
			collider.healthComponent.TakeDamage(damage)
