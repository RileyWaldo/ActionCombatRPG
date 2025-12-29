extends Control
class_name UserInterface

@export var player: Player

@onready var levelLabel: Label = %LevelLabel
@onready var healthbar: TextureProgressBar = %Healthbar
@onready var xpBar: TextureProgressBar = %XPBar
@onready var healthLabel: Label = %HealthLabel

func UpdateStatsDisplay() -> void:
	levelLabel.text = str(player.stats.level)
	xpBar.max_value = player.stats.PercentageLevelUpBoundary()
	xpBar.value = player.stats.xp

func UpdateHealth() -> void:
	healthbar.max_value = player.healthComponent.maxHealth
	healthbar.value = player.healthComponent.health
	healthLabel.text = player.healthComponent.GetHealthString()
