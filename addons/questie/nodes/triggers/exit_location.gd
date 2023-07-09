extends TriggerNode

var location_id : String

func _enter_tree():
    QuestieEvents.connect("player_exit_location", self, "on_player_exit_location")

func _exit_tree():
    QuestieEvents.disconnect("player_exit_location", self, "on_player_exit_location")

func on_player_exit_location(_location_id):
    if not location_id == _location_id: 
        return
    
    state = TaskComplention.COMPLETED
    emit_signal("trigger_activated", id)