extends Node

# The inventory
var inventory 

# The item uuid to track in inventory
var target_uuid : String

func on_item_added(var uuid : String, var category : int):

	print("[questie]: item added")


func _enter_tree():

	inventory = get_parent();

	inventory.connect("item_added", self, "on_item_added")

func _exit_tree():

	inventory.disconnect("item_added", self, "on_item_added")

	
