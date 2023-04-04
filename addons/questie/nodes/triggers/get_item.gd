extends TriggerNode

# The inventory
var inventory 

# The item uuid to track in inventory
var target_uuid : String

func on_item_added(var uuid : String, var category : int):

	#if state == TaskComplention.ONGOING:
	var target_item = inventory.get_item(uuid)
	if not target_item:
		return
		
	# check if is the correct item
	if not target_uuid == uuid:
		return
	
	state = TaskComplention.COMPLETED
	emit_signal("trigger_activated", id)

func _enter_tree():

	inventory.connect("item_added", self, "on_item_added")

func _exit_tree():

	inventory.disconnect("item_added", self, "on_item_added")

	
