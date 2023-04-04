extends TaskNode

var inventory                           # the player inventory. DO NOT SET IT!!!

export(String) var item_id            # the UUID of the items from item database
var item_category : int
export(int) var item_quantity = 1       # the amount needed to complete the task

func item_added(var item_uuid : String, var item_category : int):

	if item_uuid == item_id and state == TaskComplention.ONGOING:     
			
		
		var obj = inventory.get_item(item_id)
		if not obj:
			print("[questie]: can't retrieve item data from uuid: " + item_id + "from collect item taks")
			return
		
		# log quantity over the required quantity
		#print("Rule check: " + var2str(obj.quantity) + "/" + var2str(item_quantity))

		if obj.quantity >= item_quantity:
			state = TaskComplention.COMPLETED
			emit_signal("task_completed", id)
		else:
			state = TaskComplention.ONGOING
			emit_signal("task_updated", id)

func _enter_tree():
	tag = "QN_CollectItem"

	inventory.connect("item_added", self, "item_added")

func _exit_tree():
	inventory.disconnect("item_added", self, "item_added")

