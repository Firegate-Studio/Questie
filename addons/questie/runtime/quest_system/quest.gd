class_name Quest
extends Node

signal state_changed(quest_uuid, quest_state) 
signal constraint_added(constraint_uuid)
signal constraint_removed(constraint_uuid)
signal trigger_added(trigger_uuid)
signal trigger_removed(trigger_uuid)
signal task_added(task_uuid)
signal task_removed(task_removed)
signal reward_added(reward_uuid)
signal reward_removed(reward_uuid)

var uuid : String
var title : String
var description : String

var constraints : Array             # contains UUID for any quest constraint
var triggers : Array                # contains UUID for any quest trigger
var tasks : Array                   # contains UUID for any quest task
var rewards : Array                 # contains UUID for any quest reward

enum QuestComplention{
	IDLE,
	ONGOING,
	COMPLETED,
	FAILED
}
var state : int = QuestComplention.IDLE

# @brief                            updates the current state of the quest
# @param new_state                  the new state of the quest. See QuestComplention for further details.
func change_state(var new_state : int):
	state = new_state
	emit_signal("state_changed", uuid, state)

func add_constraint(id : String)->void: 
	constraints.append(id)
	print("Questie: recorded constraint with identifier: " + id)
	emit_signal("constraint_added", id)

func remove_constraint(id : String)->void:
	constraints.erase(id)
	print("Questie: removed constraint with identifier: " + id)
	emit_signal("constraint_removed", id)
 
func add_trigger(id : String)->void:
	triggers.append(id)
	print("Questie: recorded trigger with identifier: " + id)
	emit_signal("trigger_added", id)

func remove_trigger(id : String)->void:
	triggers.erase(id)
	print("Questie: removed trigger with identifier: " + id)
	emit_signal("trigger_removed", id)

func add_task(id : String)->void:
	tasks.append(id)
	print("Questie: recorded task with identifier: " + id)
	emit_signal("task_added", id)
	
func remove_task(id : String)->void:
	tasks.erase(id)
	print("Questie: removed task with identifier: " + id)
	emit_signal("task_removed", id)

func add_reward(id : String)->void:
	rewards.append(id)
	print("Questie: recorded reward with identifier: " + id)
	emit_signal("reward_added", id)

func remove_reward(id : String)->void:
	rewards.erase(id)
	print("Questie: removed reward with identifier: " + id)
	emit_signal("reward_removed", id)
