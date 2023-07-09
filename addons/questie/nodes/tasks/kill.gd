extends TaskNode

# the identifer of the character to kill
var character_id : String

# the amount of enemies to kill
var target_kills : int

# the current amount of kills
var current_kills : int = 0

func _enter_tree():
	QuestieEvents.connect("kill", self, "on_character_kill")

func _exit_tree():
	QuestieEvents.disconnect("kill", self, "on_character_kill")

func on_character_kill(_character_id, is_player):

	if not character_id == _character_id: return

	current_kills += 1              # increase kills count

	if current_kills >= target_kills:
		state = TaskComplention.COMPLETED
		emit_signal("task_completed", id)
		return

	state = TaskComplention.ONGOING
	emit_signal("task_updated", id)

