extends TextureButton
class_name ItemIcon

signal interact(item)

@onready var nameLabel: Label = $MarginContainer/NameLabel
@onready var statLabel: Label = $MarginContainer/StatLabel

func _on_gui_input(event: InputEvent) -> void:
	if(event.is_action("leftClick")):
		interact.emit(self)
