# This kind of inventory allows to add items by quantity untill the max possible weight is reached

class_name WeightedInventory, "res://addons/questie/editor/icons/inventory.png"
extends "res://addons/questie/runtime/Inventory System/inventory_base.gd"

# The max weight for this inventory
export(float) var max_weight = 120

class item:
	var uuid : String
	var data
	var quantity : int

var data : Array

func fetch_item(var uuid : String)->item:
	for context in data:

		# Ignore invalid uuid
		if not context.uuid == uuid: continue

		return context

	return null 

func get_current_weight()->float:

	if data.size() == 0: return 0.0

	# the total weight
	var result : float = 0

	for container in data:
		result += container.data.weight * container.quantity

	return result

# @brief                    Add an item to inventory
# @param item               The UUID of the item to add
# @param quantity           The quantity to add to inventory
func add_item(var uuid, var quantity : int = 1):

	var container = fetch_item(uuid)
	if not container:

		# Construct new slot
		container = item.new()
		container.uuid = uuid
		
		# Binary search data from database
		if InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.WEAPON): 
			container.data = InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.WEAPON)
		if not container.data and InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.ARMOR):
			container.data = InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.ARMOR)
		if not container.data and InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.CONSUMABLE):
			container.data = InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.CONSUMABLE)
		if not container.data and InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.MATERIAL):
			container.data = InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.MATERIAL)
		if not container.data and InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.SPECIAL):
			container.data = InventorySystem.item_db.find_data(uuid, InventorySystem.item_db.ItemCategory.SPECIAL)
		if not container.data:
			print("[questie]: can't retrieve data from database")
			return

		# Inspect quantity
		if container.data.weight * quantity > max_weight:

			# Bisect quantities by weight
			for n in quantity:
				if get_current_weight() + container.data.weight <= max_weight:
					container.quantity += 1
				else:
					break
		else:
			container.quantity = quantity

		data.push_back(container)
	else:
		# Inspect quantity
		if container.data.weight * quantity + get_current_weight() > max_weight:

			# Bisect quantities by weight
			for n in quantity:
				if get_current_weight() + container.data.weight <= max_weight:
					container.quantity += 1
				else:
					break
		else:
			container.quantity += quantity			

func remove_item(var item, var quantity : int = 1):

	var container = fetch_item(item)
	if not container: return

	if container.quantity - quantity == 0:
		data.erase(container)
		return

	container.quantity -= quantity

func debug():

	print("total weight: " + var2str(get_current_weight()))
	
	if data.size() == 0: return

	for item in data:
		print("uuid: " + item.uuid + " quantity: " + var2str(item.quantity))
