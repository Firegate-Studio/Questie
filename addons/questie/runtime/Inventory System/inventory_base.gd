extends Control

# Called when an item is added to inventory
signal add_item(uuid, category)

# Called when an item is removed from inventory
signal remove_item(uuid, category)

signal call_error(message)

var data : Array

# @brief                    Insert an item in inventory
func add_item(var item): pass

# @brief                    Remove an item from inventory
func remove_item(var item): pass

# @brief                    Removes all stored items from inventory
func purge():
    data.clear()
