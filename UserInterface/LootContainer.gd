extends CenterContainer
class_name LootContainerMenu

func _ready() -> void:
	visible = false
	
func ToggleMenu() -> void:
	var toggle = !visible
	visible = toggle
	if(toggle):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
