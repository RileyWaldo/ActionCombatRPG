extends CenterContainer
class_name LootContainerMenu

@export var inventory: Inventory

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
			for item: ItemIcon in loot.GetItems():
				currentContainer.remove_child(item)
				gridContainer.add_child(item)
				item.visible = true
				item.interact.connect(PickUpItem)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if(is_instance_valid(currentContainer)):
			for item: ItemIcon in gridContainer.get_children():
				gridContainer.remove_child(item)
				currentContainer.add_child(item)
				item.visible = false
				item.interact.disconnect(PickUpItem)

func PickUpItem(itemIcon: ItemIcon) -> void:
	itemIcon.interact.disconnect(PickUpItem)
	if(itemIcon is CurrencyIcon):
		inventory.AddCurrency(itemIcon.value)
		itemIcon.queue_free()
	else:
		inventory.AddItem(itemIcon)
		
func LootAll() -> void:
	var items := gridContainer.get_children()
	if(items.is_empty()):
		return
	
	for item: ItemIcon in items:
		PickUpItem(item)
