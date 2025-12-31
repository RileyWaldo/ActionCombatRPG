extends ItemIcon
class_name ShieldIcon

@export var protection: int
@export var itemModel: PackedScene

func _ready() -> void:
	statLabel.text = "+" + str(protection)
	nameLabel.text = itemModel.resource_path.get_file().rstrip("." + itemModel.resource_path.get_extension()).capitalize()
