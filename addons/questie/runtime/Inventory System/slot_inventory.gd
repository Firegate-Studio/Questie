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
func add_item(var uuid : String, var quantity : int = 1)->void:

    # Prepare item to bake data from database
    var new_item = null

    # Represents the item cateogory
    var item_category = -1
    
    # the database itself
    var database = InventorySystem.item_db

    # Retrieve item data from database
    new_item = database.find_data(uuid, database.ItemCategory.WEAPON)
    item_category = database.ItemCategory.WEAPON
    if not new_item: 
        new_item = database.find_data(uuid, database.ItemCategory.ARMOR)
        item_category = database.ItemCategory.ARMOR
    if not new_item: 
        new_item = database.find_data(uuid, database.ItemCategory.CONSUMABLE)
        item_category = database.ItemCategory.CONSUMABLE
    if not new_item: 
        new_item = database.find_data(uuid, database.ItemCategory.MATERIAL)
        item_category = database.ItemCategory.MATERIAL
    if not new_item:
        new_item = database.find_data(uuid, database.ItemCategory.SPECIAL)
        item_category = database.ItemCategory.SPECIAL
    
    # Check item validation
    if not new_item:
        print("[questie]: can't retrieve data from database for item with uuid: " + uuid)
        return
    
    # Check if inventory space is enough
    if get_current_size() + quantity <= max_slots_count:
        for n in quantity:
            data.push_back(new_item)
            emit_signal("add_item", uuid, item_category)
    else:
        var free_slots = max_slots_count - get_current_size()
        if free_slots == 0:
            print("[questie]: max inventory capacity reached!")
            return
        
        # Add items untill inventorty is filled
        for n in max_slots_count - get_current_size():
            data.push_back(new_item)
            emit_signal("add_item", uuid, item_category)

func remove_item(var uuid: String, var quantity : int = 1):

    var cache = null
    
    # The amount of target item in inventory
    var count = 0

    # Get data from inventory
    for item in data:
        if item.uuid == uuid:
            cache = item
            count += 1
    
    # Check cached item validation
    if not cache:
        # Log error
        print("[questie]: can't retrieve item data from inventory for item with uuid: " + uuid)
    
    # Get category
    var category = InventorySystem.item_db.get_item_category(uuid)
    if not category:
        # Log error
        print("[questie]: can't retrived item category for item with uuid: " + uuid)
        return

    if count - quantity < 0:
        # Removes the available amount of items
        for n in count:
            data.erase(cache)
            emit_signal("remove_item", uuid, category)
        return
    
    for n in quantity:
        data.erase(cache)
        emit_signal("remove_item", uuid, category)
    return

func debug():
    print("[questie]: current slot-inv size: " + var2str(get_current_size()))

