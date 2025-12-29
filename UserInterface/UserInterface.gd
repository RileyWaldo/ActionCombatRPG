extends Control
class_name UserInterface

@export var player: Player

@onready var levelLabel: Label = %LevelLabel

func UpdateStatsDisplay() -> void:
	levelLabel.text = str(player.stats.level)
