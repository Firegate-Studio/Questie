class_name QuestieNode
extends Node

var tag : String

enum TaskComplention{
    IDLE,
    ONGOING,
    COMPLETED,
    FAILED
}
export(TaskComplention) var state = TaskComplention.ONGOING