extends TaskNode

# the identifier of the item
var item_id : String

func _enter_tree():
	QuestieEvents.connect("interact_item", self, "on_item_interaction")

func _exit_tree():
	QuestieEvents.disconnect("interact_item", self, "on_item_interaction")

func on_item_interaction(_item_id):
	if not _item_id == item_id: return

	state = TaskComplention.COMPLETED
	emit_signal("task_completed", id)
