extends TaskNode

# the identifier of the character
var character_id

var questie_events : QuestieEvents

func _enter_tree():
    questie_events = get_node("../../QuestieEvents")
    questie_events.connect("interact_character", self, "on_character_interaction")

func _exit_tree():
    questie_events.disconnect("interact_character", self, "on_character_interaction")

func on_character_interaction(_character_id):
    if not _character_id == character_id: return

    state = TaskComplention.COMPLETED
    emit_signal("task_completed", id)