tool
extends Object 
class_name TaskCallbacksHandler

var quest_database : QuestDatabase = null

var alignment_callbacks : TaskCallbacks_AlignmentRange
var collect_callbacks : TaskCallbacks_Collect
var go_to_callbacks : TaskCallbacks_GoTo
var interact_character_callbacks : TaskCallbacks_InteractCharacter
var interact_item_callbacks : TaskCallbacks_InteractItem
var kill_callbacks : TaskCallbacks_Kill
var talk_callbacks : TaskCallbacks_Talk

func add_callbacks(task_block, data): 
	if task_block is TaskBlock_AlignmentRange:
		alignment_callbacks.add_listeners(task_block, data)
	if task_block is TaskBlock_Collect: 
		collect_callbacks.add_listeners(task_block, data)
	if task_block is TaskBlock_GoTo:
		go_to_callbacks.add_listeners(task_block, data)
	if task_block is TaskBlock_InteractCharacter:
		interact_character_callbacks.add_listeners(task_block, data)
	if task_block is TaskBlock_InteractItem:
		interact_item_callbacks.add_listeners(task_block, data)
	if task_block is TaskBlock_Kill:
		kill_callbacks.add_listeners(task_block, data)
	if task_block is TaskBlock_Talk:
		talk_callbacks.add_listeners(task_block, data)

func remove_callbacks(task_block): 
	if task_block is TaskBlock_AlignmentRange:
		alignment_callbacks.remove_listeners(task_block)
	if task_block is TaskBlock_Collect: 
		collect_callbacks.remove_listeners(task_block)
	if task_block is TaskBlock_GoTo:
		go_to_callbacks.remove_listeners(task_block)
	if task_block is TaskBlock_InteractCharacter:
		interact_character_callbacks.remove_listeners(task_block)
	if task_block is TaskBlock_InteractItem:
		interact_item_callbacks.remove_listeners(task_block)
	if task_block is TaskBlock_Kill:
		kill_callbacks.remove_listeners(task_block)
	if task_block is TaskBlock_Talk:
		talk_callbacks.remove_listeners(task_block)

func _init():
	quest_database = ResourceLoader.load("res://questie/quest-db.tres")

	alignment_callbacks = TaskCallbacks_AlignmentRange.new()
	collect_callbacks = TaskCallbacks_Collect.new()
	go_to_callbacks = TaskCallbacks_GoTo.new()
	interact_character_callbacks = TaskCallbacks_InteractCharacter.new()
	interact_item_callbacks = TaskCallbacks_InteractItem.new()
	kill_callbacks = TaskCallbacks_Kill.new()
	talk_callbacks = TaskCallbacks_Talk.new()
