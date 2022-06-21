extends Node

func _ready():

	var data = InventorySystem.get_item_data(InventorySystem.weapons["Sword of destiny"], ItemDatabase.ItemCategory.WEAPON)
	print(data.title)
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
