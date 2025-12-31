extends CenterContainer
class_name LootContainerMenu

@onready var gridContainer: GridContainer = %GridContainer
@onready var containerLabel: Label = %Label

var currentContainer: LootContainer

func _ready() -> void:
	visible = false
	
func ToggleMenu(loot: LootContainer = null) -> void:
	var toggle = !visible
	visible = toggle
	if(toggle):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if(is_instance_valid(loot)):
			containerLabel.text = loot.containerName
			currentContainer = loot
			for item in loot.GetItems():
				currentContainer.remove_child(item)
				gridContainer.add_child(item)
				item.visible = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if(is_instance_valid(currentContainer)):
			for item in gridContainer.get_children():
				gridContainer.remove_child(item)
				currentContainer.add_child(item)
				item.visible = false
