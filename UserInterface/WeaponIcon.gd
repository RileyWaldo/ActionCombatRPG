extends ItemIcon
class_name WeaponIcon

@export var power: int
@export var itemModel: PackedScene

func _ready() -> void:
	statLabel.text = "+" + str(power)
	nameLabel.text = itemModel.resource_path.get_file().rstrip("." + itemModel.resource_path.get_extension()).capitalize()
