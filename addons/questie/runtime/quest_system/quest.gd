class_name Quest
extends Node

signal state_changed(quest_uuid, quest_state) 

var uuid : String
var title : String
var description : String

var tasks : Array

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



