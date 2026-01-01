extends ItemIcon
class_name ArmorIcon

@export var protection: int
@export var armor: armorType

enum armorType {
	IRON_PLATE,
	STEEL_PLATE
}

func _ready() -> void:
	statLabel.text = "+" + str(protection)
	nameLabel.text = armorType.keys()[armor].capitalize()
