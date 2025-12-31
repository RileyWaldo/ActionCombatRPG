extends ItemIcon
class_name ArmorIcon

@export var power: int
@export var armor: armorType

enum armorType {
	IRON_PLATE,
	STEEL_PLATE
}

func _ready() -> void:
	statLabel.text = "+" + str(power)
	nameLabel.text = armorType.keys()[armor].capitalize()
