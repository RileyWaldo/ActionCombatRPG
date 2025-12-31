extends Control
class_name UserInterface

@export var player: Player

@onready var levelLabel: Label = %LevelLabel
@onready var healthbar: TextureProgressBar = %Healthbar
@onready var xpBar: TextureProgressBar = %XPBar
@onready var healthLabel: Label = %HealthLabel
@onready var inventory: Inventory = $Inventory
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var interactLabel: Label = %InteractLabel


func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("openMenu")):
		ToggleMenu()

func UpdateStatsDisplay() -> void:
	levelLabel.text = str(player.stats.level)
	xpBar.max_value = player.stats.PercentageLevelUpBoundary()
	xpBar.value = player.stats.xp
	inventory.UpdateStats()

func UpdateHealth() -> void:
	healthbar.max_value = player.healthComponent.maxHealth
	healthbar.value = player.healthComponent.health
	healthLabel.text = player.healthComponent.GetHealthString()

func ToggleMenu() -> void:
	var paused := !inventory.visible
	inventory.visible = paused
	get_tree().paused = paused
	if(paused):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		inventory.UpdateGearStats()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func InteractText(text: String) -> void:
	animationPlayer.stop()
	animationPlayer.play("FadeOutText")
	interactLabel.text = text
