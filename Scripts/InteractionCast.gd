extends ShapeCast3D
class_name InteractionCast

@export var ui: UserInterface

func CheckInteractions() -> void:
	for collisions in get_collision_count():
		var collider = get_collider(collisions)
		match collider:
			var chest when chest is LootContainer:
				ui.InteractText("Open Chest")
				if(Input.is_action_just_pressed("interact")):
					ui.ToggleLootMenu(chest)
			
