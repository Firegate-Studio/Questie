extends "res://addons/questie/nodes/constraints/constraint_node.gd"

# the quest node to get the current state
var quest 

func _enter_tree(): 
    quest.connect("state_changed", self, "update_constraint")

func _exit_tree(): 
    quest.disconnect("state_changed", self, "update_constraint")

func update_constraint(quest_id, quest_state): 
    if quest.state == Quest.QuestComplention.ONGOING:
        bypassed = true
        emit_signal("constraint_passed", id)
    else:
        bypassed = false
        emit_signal("constraint_failed", id)