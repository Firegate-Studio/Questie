class_name InventoryBase, "res://addons/questie/editor/icons/inventory.png"
extends Control

# Called when an item is added to inventory
signal item_added(id)

# Called when an item is removed from inventory
signal item_removed(id)

signal call_error(message)

var data : Array

# Used to get the item across multiples inventories
class ResultItem:
	var id : String
	var data
	var quantity : int

# @brief                    Insert an item in inventory
func add_item(id : String): pass

# @brief                    Remove an item from inventory
func remove_item(id : String): pass

func get_item(id : String)->ResultItem: return null

# @brief                    Removes all stored items from inventory
func purge():
	data.clear()
