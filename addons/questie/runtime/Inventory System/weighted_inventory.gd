# This kind of inventory allows to add items by quantity untill the max possible weight is reached

class_name WeightedInventory, "res://addons/questie/editor/icons/inventory.png"
extends "res://addons/questie/runtime/Inventory System/inventory_base.gd"

# The max weight for this inventory
export(float) var max_weight = 200

class item:
	var id : String
	var data
	var quantity : int

func fetch_item(id : String)->item:
	for context in data:

		# Ignore invalid uuid
		if not context.id == id: continue

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
func add_item(id, var quantity : int = 1):

	var container = fetch_item(id)
	if not container:

		# Construct new slot
		container = item.new()
		container.uuid = id
		
		# get data from database
		container.data = load("res://questie/item-db.tres").get_item(id)

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
		emit_signal("item_added", id)
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
			emit_signal("item_added", id)			

func remove_item(id : String, var quantity : int = 1):

	var container = fetch_item(id)
	if not container: return

	if container.quantity - quantity == 0:
		data.erase(container)
		return

	container.quantity -= quantity

func get_item(id : String)->ResultItem:
	for obj in data:
		if not obj.id == id: continue

		var result = ResultItem.new()
		result.id = obj.uuid
		result.data = obj.data
		result.quantity = obj.quantity

		return result	

	return null

func debug():

	print("total weight: " + var2str(get_current_weight()))
	
	if data.size() == 0: return

	for item in data:
		print("uuid: " + item.uuid + " quantity: " + var2str(item.quantity))
