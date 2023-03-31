extends "res://addons/questie/nodes/constraints/constraint_node.gd"

export(String) var target_state             # the UUID of the quest state to pass this constraint

func _enter_tree():
	tag = "QN_QuestStateConstraint"


func _exit_tree():
	
	# Unsub events
	questie.disconnect("quest_completed", self, "on_constraint_update")
	questie.disconnect("quest_failed", self, "on_constraint_update")

func on_constraint_update(quest_uuid):

	var quest = questie.get_game_quest(quest_uuid)
	if not quest:       # check quest validation
		# Log error
		print("[Questie]: can not retrieve quest with id: " + quest_uuid + " from quest director")
		return

	if quest.state == target_state: 
		state = TaskComplention.COMPLETED
		print("[Questie]: constraint check passed - quest state matches")
		emit_signal("constraint_passed")
	else:
		state = TaskComplention.ONGOING
		print("[Questie]: constraint check failed - quest state does not matches")
		emit_signal("constraint_failed")



