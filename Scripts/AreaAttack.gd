extends ShapeCast3D
class_name AreaAttack

func DealDamage(damage: float, critChance: float) -> void:
	for collision in get_collision_count():
		var collider = get_collider(collision)
		if(collider is Player or collider is Enemy):
			var isCrit = randf() <= critChance
			collider.healthComponent.TakeDamage(damage, isCrit)
