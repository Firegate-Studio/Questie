class_name InventoryBase, "res://addons/questie/editor/icons/inventory.png"
extends Control

# Called when an item is added to inventory
signal item_added(uuid, category)

# Called when an item is removed from inventory
signal item_removed(uuid, category)

signal call_error(message)

var data : Array

# Used to get the item across multiples inventories
class ResultItem:
	var uuid : String
	var data
	var quantity : int

# @brief                    Insert an item in inventory
func add_item(var item): pass

# @brief                    Remove an item from inventory
func remove_item(var item): pass

func get_item(var uuid)->ResultItem: return null

# @brief                    Removes all stored items from inventory
func purge():
	data.clear()
