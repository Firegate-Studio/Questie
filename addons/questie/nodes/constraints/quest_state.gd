extends "res://addons/questie/nodes/constraints/constraint_node.gd"

export(String) var target_state             # the UUID of the quest state to pass this constraint
var quest : Quest

func _enter_tree():
	tag = "QN_QuestStateConstraint"

	quest.connect("state_changed", self, "constraint_update")


func _exit_tree():
	quest.disconnect("state_changed", self, "constraint_update")

func constraint_update(quest_id, state):

	if quest.state == target_state: 
		bypassed = true
		print("[Questie]: constraint check passed - quest state matches")
		emit_signal("constraint_passed")
	else:
		bypassed = false
		print("[Questie]: constraint check failed - quest state does not matches")
		emit_signal("constraint_failed")



