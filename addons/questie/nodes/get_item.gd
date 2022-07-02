extends Node

var questie : QuestDirector 

# The inventory
var inventory 

# The item uuid to track in inventory
var target_uuid : String
var quest_uuid : String 
var uuid : String

func on_item_added(var uuid : String, var category : int):

	print("[questie]: node trigger activated!")
	questie.emit_signal("trigger_activated", quest_uuid, uuid, self)


func _enter_tree():

	inventory = get_parent();

	inventory.connect("item_added", self, "on_item_added")

func _exit_tree():

	inventory.disconnect("item_added", self, "on_item_added")

	
