tool
extends Resource

# the identifier of the character
export(String) var id

# the name for the character item
export(String) var title

# the character name
export(String) var name

# the character surname
export(String) var surname

# the character alignment - i.e., good or evil
export var alignment : float

# the character bio
export(String) var biography

# the character background
export(String) var background

# the character note - used as memo for the use
export(String) var note

# the parent item of this one - used with the editor
export(String) var parent

# check if the character has a game shop
export(bool) var is_vendor

# check if the character is a mob
export(bool) var has_loot

# check if the character has an inventory
export(bool) var has_inventory

# the inventory of the character
export(Array) var inventory

# the shop of the character
export(Array) var shop

# the loot of the character
export(Array) var loot

# add the inventory data to the inventory
func add_item_data_to_inventory(data):
    inventory.push_back(data)


func remove_item_data_to_inventory(item_id):
    for item in inventory:
        if not item.id == item_id: continue
        
        inventory.erase(item)
        break 

# try to find and get the item data from inventory - if none is found will return NULL
func get_item_data_from_inventory(item_id):
    for item in inventory:
        if not item.id == item_id: continue

        return item
    return null

