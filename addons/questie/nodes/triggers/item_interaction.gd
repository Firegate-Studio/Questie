extends TriggerNode

# the identifier of the item
var item_id : String

# the category of the item
var item_category

var questie_events : QuestieEvents

func _enter_tree():
    questie_events = $"../../QuestieEvents"
    questie_events.connect("interact_item", self, "on_item_interaction")

func on_item_interaction(_item_id):
    if item_id != item_id : return

    state = TaskComplention.COMPLETED
    emit_signal("trigger_activated", id)        # call this event to execute trigger or task activation
    questie_events.disconnect("interact_character", self, "on_item_interaction")
