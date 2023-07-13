class_name RealisticInventory, "res://addons/questie/editor/icons/inventory.png"
extends "res://addons/questie/runtime/Inventory System/inventory_base.gd"

# The maximum amount of accumulable items for each slot in inventory
export(int) var max_slot_capacity = 25

class item:
	var id : String
	var data
	var quantity : int

# @brief                Check if an item is present in inventory and get it
# @param uuid           the item UUID
func fetch(id : String):
	for obj in data:
		if obj.id == id:
			return obj
	return null

func add_item(id : String, quantity : int = 1):

	# Get database
	var database = load("res://questie/item-db.tres")

	# Check if item is already added to inventory
	var container = fetch(id)
	if not container: 
		# Add item for the first time
		container = item.new()
		container.id = id
		
		container.data = database.get_item(id)
		if not container.data:
			# Log error
			print("[questie]: can't retrieve data for item with uuid: " + id)
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
		emit_signal("item_added", id)
	else:
		# update item quantity
		if container.quantity + quantity > max_slot_capacity:
			# Ensure we will add only allowed quantities to the slot.
			# If the slot exceed that quantity, we add the maximum 
			# amount allowed
			container.quantity = clamp(container.quantity + quantity, 0, max_slot_capacity)
		else:
			container.quantity += quantity
		
		emit_signal("item_added", id)

# @brief                    Remove one item or many from inventory
# @param uuid               the item uuid
# @param quantity           the amount to remove
func remove_item(id : String, var quantity : int = 1)->void:

	# Reference database
	var database = InventorySystem.item_db

	# Check item container validation
	var container = fetch(id)
	if not container:
		# Log error
		print("[questie]: can't retrived item from inventory for item with uuid: " + id)
		return
	
	# Check if quantity nullify item
	if container.quantity - quantity == 0 or container.quantity - quantity < 0:
		data.erase(container)
		emit_signal("item_removed", id)
	else:
		container.quantity -= quantity
		emit_signal("item_removed", id)

# @brief					Return the item inside inventory if exists
# @param uuid				the item UUID
func get_item(var id : String)->ResultItem:
	for item in data:
		if not item.id == id: continue
		
		var result = ResultItem.new()
		result.id = id
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
		print("item: " + container.data.name + "(" + container.id + ") - quantity: " + var2str(container.quantity))
