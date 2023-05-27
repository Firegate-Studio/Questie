extends TaskNode

# the identifier of the character
var character_id : String

var questie_events : QuestieEvents

func _enter_tree():
	questie_events = get_node("../../QuestieEvents")
	questie_events.connect("talk", self, "on_character_talk")

func _exit_tree():
	questie_events.disconnect("talk", self, "on_character_talk")

func on_character_talk(_character_id):
	if not character_id == _character_id: 
		print("[Questie]: the character identifier does not match")
		return

	state = TaskComplention.COMPLETED
	emit_signal("task_completed", id)
