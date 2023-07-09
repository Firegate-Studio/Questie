extends Node
class_name ItemTag, "res://addons/questie/editor/icons/tag.png"

# the name of the item created using the item editor
export(String) var tag
export(ItemDatabase.ItemCategory) var category

func get_item_id():

	var result
	match category:
		ItemDatabase.ItemCategory.WEAPON:
			result = InventorySystem.weapons[tag]
		ItemDatabase.ItemCategory.ARMOR:
			result = InventorySystem.armors[tag]
		ItemDatabase.ItemCategory.CONSUMABLE:
			result = InventorySystem.consumables[tag]
		ItemDatabase.ItemCategory.MATERIAL:
			result = InventorySystem.materials[tag]
		ItemDatabase.ItemCategory.SPECIAL:
			result = InventorySystem.specials[tag]

	return result

	
