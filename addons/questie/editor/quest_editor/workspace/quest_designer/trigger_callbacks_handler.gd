tool
extends Object
class_name TriggerCallbacksHandler

var quest_database : QuestDatabase

var enter_location_callbacks : CharacterEnterLocationCallbacks
var exit_location_callbacks : TriggerCallbacks_CharacterExitLocation
var get_item_callbacks : TriggerCallbacks_GetItem
var interact_character_callbacks : TriggerCallbacks_InteractCharacter
var interact_item_callbacks : TriggerCallbacks_InteractItem

func add_callbacks(trigger_block, data):
	if trigger_block is TriggerBlock_HasAlignmentRange:
		trigger_block.connect("alignment_range_changed", self, "on_character_alignment_range_changed", [data])
	if trigger_block is TriggerBlock_CharacterEnterLocation:
		enter_location_callbacks.add_listeners(trigger_block, data)
	if trigger_block is TriggerBlock_CharacterExitLocation:
		exit_location_callbacks.add_listeners(trigger_block, data)
	if trigger_block is TriggerBlock_GetItem:
		get_item_callbacks.add_listeners(trigger_block, data)
	if trigger_block is TriggerBlock_InteractCharacter: 
		interact_character_callbacks.add_listeners(trigger_block, data)
	if trigger_block is TriggerBlock_InteractItem: 
		interact_item_callbacks.add_listeners(trigger_block, data)

		
	print(typeof(trigger_block))

func remove_callbacks(trigger_block):
	if trigger_block is TriggerBlock_HasAlignmentRange:
		trigger_block.disconnect("alignment_range_changed", self, "on_character_alignment_range_changed")
	if trigger_block is TriggerBlock_CharacterEnterLocation:
		enter_location_callbacks.remove_listeners(trigger_block)
	if trigger_block is TriggerBlock_CharacterExitLocation:
		exit_location_callbacks.remove_listeners(trigger_block)
	if trigger_block is TriggerBlock_GetItem:
		get_item_callbacks.remove_listeners(trigger_block)
	if trigger_block is TriggerBlock_InteractCharacter:
		interact_character_callbacks.remove_listeners(trigger_block)
	if trigger_block is TriggerBlock_InteractItem:
		interact_item_callbacks.remove_listeners(trigger_block)

func _init():
	quest_database = ResourceLoader.load("res://questie/quest-db.tres")
	enter_location_callbacks = CharacterEnterLocationCallbacks.new()
	exit_location_callbacks = TriggerCallbacks_CharacterExitLocation.new()
	get_item_callbacks = TriggerCallbacks_GetItem.new()
	interact_character_callbacks = TriggerCallbacks_InteractCharacter.new()
	interact_item_callbacks = TriggerCallbacks_InteractItem.new()

func on_character_alignment_range_changed(current_min, current_max, data):
	data.min_value = current_min
	data.max_value = current_max
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)
