extends TriggerNode

var location_id : String

var questie_events : QuestieEvents

func _enter_tree():
    questie_events = get_node("../../QuestieEvents")
    questie_events.connect("player_exit_location", self, "on_player_exit_location")

func _exit_tree():
    questie_events.disconnect("player_exit_location", self, "on_player_exit_location")

func on_player_exit_location(_location_id):
    if not location_id == _location_id: 
        return
    
    state = TaskComplention.COMPLETED
    emit_signal("trigger_activated", id)