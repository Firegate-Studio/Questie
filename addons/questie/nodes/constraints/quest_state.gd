extends "res://addons/questie/nodes/constraints/constraint_node.gd"

var target_state             # the UUID of the quest state to pass this constraint
var quest : Quest

func _enter_tree():
	tag = "QN_QuestStateConstraint"

	quest.connect("state_changed", self, "constraint_update")


func _exit_tree():
	quest.disconnect("state_changed", self, "constraint_update")

func constraint_update(quest_id, state):

	#print("quest state: " + var2str(quest.state) + "/" + var2str(target_state))

	if quest.state == target_state: 
		bypassed = true
		emit_signal("constraint_passed", id)
	else:
		bypassed = false
		emit_signal("constraint_failed", id)



