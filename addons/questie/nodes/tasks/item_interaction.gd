extends TaskNode

# the identifier of the item
var item_id : String

# the category of the item
var category

var questie_events : QuestieEvents

func _enter_tree():
    questie_events = get_node("../../QuestieEvents")
    questie_events.connect("interact_item", self, "on_item_interaction")

func _exit_tree():
    questie_events.disconnect("interact_item", self, "on_item_interaction")

func on_item_interaction(_item_id):
    if not _item_id == item_id: return

    state = TaskComplention.COMPLETED
    emit_signal("task_completed", id)