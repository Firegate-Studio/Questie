class_name RealisticInventory, "res://addons/questie/editor/icons/inventory.png"
extends "res://addons/questie/runtime/Inventory System/inventory_base.gd"

# The maximum amount of accumulable items for each slot in inventory
export(int) var max_slot_capacity = 25

class item:
	var uuid : String
	var data
	var quantity : int

# @brief                Check if an item is present in inventory and get it
# @param uuid           the item UUID
func fetch(var uuid : String):
	for obj in data:
		if obj.uuid == uuid:
			return obj
	return null

func add_item(var uuid : String, var quantity : int = 1):

	# Get database
	var database = InventorySystem.item_db

	var category = database.get_item_category(uuid)

	# Check if item is already added to inventory
	var container = fetch(uuid)
	if not container: 
		# Add item for the first time
		container = item.new()
		container.uuid = uuid
		
		container.data = database.find_data(uuid, category)
		if not container.data:
			# Log error
			print("[questie]: can't retrieve data for item with uuid: " + uuid)
			return

		# Check quantity validation
		if quantity > max_slot_capacity:
			# fill slot quantity to maximum capacity
			container.quantity = max_slot_capacity
		else:
			# add quantity
			container.quantity = quantity
		
		# Store data
		data.push_back(container)
		emit_signal("item_added", uuid, category)
	else:
		# update item quantity
		if container.quantity + quantity > max_slot_capacity:
			# Ensure we will add only allowed quantities to the slot.
			# If the slot exceed that quantity, we add the maximum 
			# amount allowed
			container.quantity = clamp(container.quantity + quantity, 0, max_slot_capacity)
		else:
			container.quantity += quantity
		
		emit_signal("item_added", uuid, quantity)

# @brief                    Remove one item or many from inventory
# @param uuid               the item uuid
# @param quantity           the amount to remove
func remove_item(var uuid : String, var quantity : int = 1)->void:

	# Reference database
	var database = InventorySystem.item_db

	# Check item container validation
	var container = fetch(uuid)
	if not container:
		# Log error
		print("[questie]: can't retrived item from inventory for item with uuid: " + uuid)
		return

	# Retrieve item category
	var category = database.get_item_category(uuid)
	
	# Check if quantity nullify item
	if container.quantity - quantity == 0 or container.quantity - quantity < 0:
		data.erase(container)
		emit_signal("item_removed", uuid, category)
	else:
		container.quantity -= quantity
		emit_signal("item_removed", uuid, category)

# @brief					Return the item inside inventory if exists
# @param uuid				the item UUID
func get_item(var uuid : String)->ResultItem:
	for item in data:
		if not item.uuid == uuid: continue
		
		var result = ResultItem.new()
		result.uuid = uuid
		result.data = item.data
		result.quantity = item.quantity
		return result

	return null

# Log inventory informations
func debug()->void:
	
	print("[questie]: inventory size: " + var2str(data.size()))
	
	if data.size() == 0: return
	
	for container in data:
		if not container is item: 
			print("porco dio")
			return
		print("item: " + container.data.title + "(" + container.uuid + ") - quantity: " + var2str(container.quantity))
