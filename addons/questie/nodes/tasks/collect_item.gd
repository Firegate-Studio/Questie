extends TaskNode

var inventory                           # the player inventory. DO NOT SET IT!!!

export(String) var item_uuid            # the UUID of the items from item database
export(int) var item_quantity = 1       # the amount needed to complete the task

func item_added(var item_uuid : String, var item_category : int):

	if state == TaskComplention.ONGOING:
		if item_uuid == self.item_uuid:     
			
			var obj = inventory.get_item(item_uuid)
			if not obj:
				print("[questie]: can't retrieve item data from uuid: " + item_uuid)
				return
				
			if obj.quantity >= item_quantity:
				state = TaskComplention.COMPLETED
				emit_signal("task_completed", id)
			else:
				emit_signal("task_updated", id)

func _enter_tree():
	tag = "QN_CollectItem"

	inventory.connect("item_added", self, "item_added")

func _exit_tree():
	inventory.disconnect("item_added", self, "item_added")

