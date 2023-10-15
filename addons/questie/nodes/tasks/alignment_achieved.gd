extends TaskNode

var min_value : float
var max_value : float


func _enter_tree():
    QuestieEvents.connect("character_alignment_changed", self, "on_character_alignment")

func _exit_tree():
    QuestieEvents.disconnect("character_alignment_changed", self, "on_character_alignment")

func on_character_alignment(character_id, alignment):

    if alignment >= min_value and alignment <= max_value: 
        state = TaskComplention.COMPLETED
        emit_signal("task_completed", id)
    else:
        state = TaskComplention.ONGOING
        emit_signal("task_updated", id)