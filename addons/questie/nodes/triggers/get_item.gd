extends TriggerNode

# The inventory
var inventory 

# The item uuid to track in inventory
var target_uuid : String

func on_item_added(var uuid : String, var category : int):

	var target_item = inventory.get_item(uuid)
	if not target_item:
		return
	
	print("[Questie]: activated trigger with identifier: " + self.id)
	emit_signal("trigger_activated", id)

func _enter_tree():

	inventory.connect("item_added", self, "on_item_added")

func _exit_tree():

	inventory.disconnect("item_added", self, "on_item_added")

	
