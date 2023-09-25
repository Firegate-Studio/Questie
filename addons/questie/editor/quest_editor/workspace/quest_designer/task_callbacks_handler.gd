tool
extends Object 
class_name TaskCallbacksHandler

var quest_database : QuestDatabase = null

var collect_callbacks : TaskCallbacks_Collect
var go_to_callbacks : TaskCallbacks_GoTo
var interact_character_callbacks : TaskCallbacks_InteractCharacter

func add_callbacks(task_block, data): 
    if task_block is TaskBlock_Collect: 
        collect_callbacks.add_listeners(task_block, data)
    if task_block is TaskBlock_GoTo:
        go_to_callbacks.add_listeners(task_block, data)
    if task_block is TaskBlock_InteractCharacter:
        interact_character_callbacks.add_listeners(task_block, data)
    if task_block is TaskBlock_InteractItem:
        pass
    if task_block is TaskBlock_Kill:
        pass
    if task_block is TaskBlock_Talk:
        pass

func remove_callbacks(task_block): 
    if task_block is TaskBlock_Collect: 
        collect_callbacks.remove_listeners(task_block)
    if task_block is TaskBlock_GoTo:
        go_to_callbacks.remove_listeners(task_block)
    if task_block is TaskBlock_InteractCharacter:
        interact_character_callbacks.remove_listeners(task_block)
    if task_block is TaskBlock_InteractItem:
        pass
    if task_block is TaskBlock_Kill:
        pass
    if task_block is TaskBlock_Talk:
        pass

func _init():
    quest_database = ResourceLoader.load("res://questie/quest-db.tres")

    collect_callbacks = TaskCallbacks_Collect.new()
    go_to_callbacks = TaskCallbacks_GoTo.new()
    interact_character_callbacks = TaskCallbacks_InteractCharacter.new()