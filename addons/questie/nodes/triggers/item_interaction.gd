extends TriggerNode

# the identifier of the item
var item_id : String

# the category of the item
var item_category

func _enter_tree():
    QuestieEvents.connect("interact_item", self, "on_item_interaction")

func on_item_interaction(_item_id):
    if item_id != item_id : return

    state = TaskComplention.COMPLETED
    emit_signal("trigger_activated", id)        # call this event to execute trigger or task activation
    QuestieEvents.disconnect("interact_character", self, "on_item_interaction")