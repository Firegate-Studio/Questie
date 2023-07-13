class_name SlotInventory, "res://addons/questie/editor/icons/inventory.png"
extends  "res://addons/questie/runtime/Inventory System/inventory_base.gd"

# Defines the maximum number of slots this inventory can handle
export(int) var max_slots_count = 20

# Get the number of slots stored into inventory
func get_current_size(): 
	return data.size()

# @brief                Insert an item in inventory
# @param uuid           the item UUID
# @param quantity       the quantity to add
func add_item(id : String, var quantity : int = 1)->void:

	# Prepare item to bake data from database
	var new_item = null

	# Represents the item cateogory
	var item_category = -1
	
	# the database itself
	var database = InventorySystem.item_db

	# Retrieve item data from database
	new_item = database.get_item(id)
	if not new_item:
		print("[Quesite]: can not retrieve item data from items-database")
		return
	
	# Check if inventory space is enough
	if get_current_size() + quantity <= max_slots_count:
		for n in quantity:
			data.push_back(new_item)
			emit_signal("item_added", id, item_category)
	else:
		var free_slots = max_slots_count - get_current_size()
		if free_slots == 0:
			print("[questie]: max inventory capacity reached!")
			return
		
		# Add items untill inventorty is filled
		for n in max_slots_count - get_current_size():
			data.push_back(new_item)
			emit_signal("item_added", id, item_category)

func remove_item(id: String, var quantity : int = 1):

	var cache = null
	
	# The amount of target item in inventory
	var count = 0

	# Get data from inventory
	for item in data:
		if item.uuid == id:
			cache = item
			count += 1
	
	# Check cached item validation
	if not cache:
		# Log error
		print("[questie]: can't retrieve item data from inventory for item with uuid: " + id)

	if count - quantity < 0:
		# Removes the available amount of items
		for n in count:
			data.erase(cache)
			emit_signal("item_removed", id, null)
		return
	
	for n in quantity:
		data.erase(cache)
		emit_signal("item_removed", id, null)
	return

func get_item(id: String):
	
	var quantity = 0
	var tmp_data 
	for item in data:
		if not item.uuid == id:
			continue
		
		quantity += 1
		tmp_data = item

	if quantity == 0: return null 

	var result = ResultItem.new()
	result.uuid = id
	result.data = tmp_data
	result.quantity = quantity

	return result
		

func debug():
	print("[questie]: current slot-inv size: " + var2str(get_current_size()))

