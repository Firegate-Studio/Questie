class_name QuestieNode
extends Node

var tag : String
var id : String                         # the idenfier of the node
var quest_id : String                   # the identifier of the quest owning this node

enum TaskComplention{
	IDLE,
	ONGOING,
	COMPLETED,
	FAILED
}
var state = TaskComplention.IDLE
