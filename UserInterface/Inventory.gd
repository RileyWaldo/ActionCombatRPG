extends Control
class_name Inventory

const MIN_ARMOR_RATING := 0.0
const MAX_ARMOR_RATING := 80.0

signal armorChanged(protection: float)

@onready var levelLabel: Label = %LevelLabel
@onready var strengthValue: Label = %StrengthValue
@onready var agilityValue: Label = %AgilityValue
@onready var speedValue: Label = %SpeedValue
@onready var enduranceValue: Label = %EnduranceValue
@onready var rig: Rig = $MarginContainer/VBoxContainer/HBoxContainer/SubViewportContainer/SubViewport/Rig
@onready var itemGrid: GridContainer = %ItemGrid
@onready var attackValue: Label = %AttackValue
@onready var armorValue: Label = %ArmorValue
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
	
	var armorProtectionValue := GetArmorValue()
	armorValue.text = str(int(armorProtectionValue))
	armorChanged.emit(armorProtectionValue)

func GetWeaponValue() -> int:
	var damage = 0
	var weapon := GetWeapon()
	if(is_instance_valid(weapon)):
		damage += weapon.power
	damage += player.stats.GetDamageModifier()
	return damage

func GetArmorValue() -> float:
	var protection := 0.0
	var armor := GetArmor()
	var shield := GetShield()
	if(is_instance_valid(armor)):
		protection += armor.protection
	if(is_instance_valid(shield)):
		protection += shield.protection
	return clampf(protection, MIN_ARMOR_RATING, MAX_ARMOR_RATING)
	
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
			get_tree().call_group("playerRig", "ReplaceWeapon", weapon.itemModel)
		
		var shield when shield is ShieldIcon:
			EquipItem(shield, shieldSlot)
			get_tree().call_group("playerRig", "ReplaceShield", shield.itemModel)
		
		var  armor when armor is ArmorIcon:
			EquipItem(armor, armorSlot)
			get_tree().call_group("playerRig", "ReplaceArmor", armor.armor)
			
	UpdateGearStats()
	
func GetWeapon() -> WeaponIcon:
	if(weaponSlot.get_child_count() != 1):
		return null
	
	return weaponSlot.get_child(0)

func GetShield() -> ShieldIcon:
	if(shieldSlot.get_child_count() != 1):
		return null
	
	return shieldSlot.get_child(0)

func GetArmor() -> ArmorIcon:
	if(armorSlot.get_child_count() != 1):
		return null
	
	return armorSlot.get_child(0)

func _on_back_button_pressed() -> void:
	var parent: UserInterface = get_parent()
	parent.ToggleMenu()
