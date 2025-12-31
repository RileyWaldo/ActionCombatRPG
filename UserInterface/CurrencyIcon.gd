extends ItemIcon
class_name CurrencyIcon

@export var value: int

func _ready() -> void:
	statLabel.text = str(value)
