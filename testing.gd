extends Node

func _ready():

	var data = InventorySystem.get_item_data(InventorySystem.weapons["Damascus"], ItemDatabase.ItemCategory.WEAPON)
	print(data.title)
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))
	print("damage: " + var2str(InventorySystem.get_weapon_damage(data.uuid)))

	var inv = get_parent().get_node("WeightedInventory")
	inv.add_item(InventorySystem.weapons["Spada Figa"], 10)
	inv.debug()
	inv.add_item(InventorySystem.weapons["Damascus"], 20)
	inv.debug()
	inv.add_item(InventorySystem.weapons["Damascus"], 500)
	inv.debug()
	inv.add_item(InventorySystem.weapons["Damascus"], 1000)
	inv.debug()

	print() # space

	var sinv = get_parent().get_node("SlotInventory")
	sinv.add_item(InventorySystem.weapons["Damascus"], 1000)
	sinv.debug()

	print() # space

	var rinv = get_parent().get_node("RealisticInventory")
	rinv.add_item(InventorySystem.weapons["Damascus"], 10)
	rinv.debug()
	rinv.add_item(InventorySystem.weapons["Damascus"], 50)
	rinv.debug()
	rinv.remove_item(InventorySystem.weapons["Damascus"], 10)
	rinv.debug()
	rinv.remove_item(InventorySystem.weapons["Damascus"], 50)
	rinv.debug()
	rinv.add_item(InventorySystem.weapons["Damascus"], 100)
	rinv.debug()
	rinv.purge()
	rinv.debug()

