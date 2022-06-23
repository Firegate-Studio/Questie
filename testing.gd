extends Node

func _ready():

	var data = InventorySystem.get_item_data(InventorySystem.weapons["Sword of destiny"], ItemDatabase.ItemCategory.WEAPON)
	print(data.title)
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))

	var inv = get_parent().get_node("WeightedInventory")
	inv.add_item(InventorySystem.weapons["Damascus"], 10)
	inv.debug()
	inv.add_item(InventorySystem.weapons["Damascus"], 20)
	inv.debug()
	inv.add_item(InventorySystem.weapons["Damascus"], 500)
	inv.debug()
	inv.add_item(InventorySystem.weapons["Damascus"], 1000)
	inv.debug()

