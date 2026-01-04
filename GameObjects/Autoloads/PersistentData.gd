extends Control

@onready var inventoryNodes: Control = $InventoryNodes
@onready var weaponNode: Control = $WeaponNode
@onready var shieldNode: Control = $ShieldNode
@onready var armorNode: Control = $ArmorNode

var playerHealth := 0.0
var gold := 0

func CacheGear(player: Player) -> void:
	gold = player.userInterface.inventory.gold
	for item in player.userInterface.inventory.itemGrid.get_children():
		CacheItem(item, inventoryNodes)
	CacheItem(player.userInterface.inventory.GetWeapon(), weaponNode)
	CacheItem(player.userInterface.inventory.GetShield(), shieldNode)
	CacheItem(player.userInterface.inventory.GetArmor(), armorNode)

func CachePlayerData(player: Player) -> void:
	playerHealth = player.healthComponent.health

func GetInventory() -> Array:
	return inventoryNodes.get_children()

func GetEquippedItems() -> Array:
	var equippedItems = []
	if(weaponNode.get_child_count() > 0):
		equippedItems.append(weaponNode.get_child(0))
	if(shieldNode.get_child_count() > 0):
		equippedItems.append(shieldNode.get_child(0))
	if(armorNode.get_child_count() > 0):
		equippedItems.append(armorNode.get_child(0))
	
	return equippedItems

func CacheItem(item: ItemIcon, storageNode: Control) -> void:
	if(!is_instance_valid(item)):
		return
	item.get_parent().remove_child(item)
	storageNode.add_child(item)
