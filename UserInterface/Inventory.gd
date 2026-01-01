extends Control
class_name Inventory

@onready var levelLabel: Label = %LevelLabel
@onready var strengthValue: Label = %StrengthValue
@onready var agilityValue: Label = %AgilityValue
@onready var speedValue: Label = %SpeedValue
@onready var enduranceValue: Label = %EnduranceValue
@onready var rig: Rig = $MarginContainer/VBoxContainer/HBoxContainer/SubViewportContainer/SubViewport/Rig
@onready var itemGrid: GridContainer = %ItemGrid
@onready var attackValue: Label = %AttackValue
@onready var goldLabel: Label = %GoldLabel
@onready var weaponSlot: CenterContainer = %WeaponSlot
@onready var shieldSlot: CenterContainer = %ShieldSlot
@onready var armorSlot: CenterContainer = %ArmorSlot

@onready var player: Player = get_parent().player
@onready var gold := 0:
	set(value):
		gold = value
		goldLabel.text = str(gold) + "g"

func _ready() -> void:
	UpdateStats()
	
func _process(delta: float) -> void:
	var inputVector := Input.get_vector("moveLeft", "moveRight", "moveBackward", "moveForward")
	rig.rotation.y += inputVector.x * delta * 8.0

func UpdateStats() -> void:
	levelLabel.text = "Level: %s" % player.stats.level
	strengthValue.text = str(player.stats.strength.abilityScore)
	agilityValue.text = str(player.stats.agility.abilityScore)
	speedValue.text = str(player.stats.speed.abilityScore)
	enduranceValue.text = str(player.stats.endurance.abilityScore)
	
func UpdateGearStats() -> void:
	rig.rotation.y = 0.0
	attackValue.text = str(GetWeaponValue())

func GetWeaponValue() -> int:
	var damage = player.baseDamage
	damage += player.stats.GetDamageModifier()
	return damage
	
func AddItem(itemIcon: ItemIcon) -> void:
	for connection in itemIcon.interact.get_connections():
		itemIcon.interact.disconnect(connection.callable)
	
	itemIcon.get_parent().remove_child(itemIcon)
	itemGrid.add_child(itemIcon)
	itemIcon.interact.connect(Interact)

func AddCurrency(currencyIn: int) -> void:
	gold += currencyIn
	
func EquipItem(item: ItemIcon, itemSlot: CenterContainer) -> void:
	for child in itemSlot.get_children():
		AddItem(child)
		
	item.get_parent().remove_child(item)
	itemSlot.add_child(item)
	
func Interact(item: ItemIcon) -> void:
	match item:
		var weapon when weapon is WeaponIcon:
			EquipItem(weapon, weaponSlot)
			
	UpdateGearStats()

func _on_back_button_pressed() -> void:
	var parent: UserInterface = get_parent()
	parent.ToggleMenu()
