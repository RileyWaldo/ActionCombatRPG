extends StaticBody3D
class_name LootContainer

func GetItems() -> Array:
	return get_children().filter(
		func(child): return child is ItemIcon
		)
