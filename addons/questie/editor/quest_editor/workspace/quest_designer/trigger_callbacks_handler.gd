tool
extends Object
class_name TriggerCallbacksHandler

var quest_database : QuestDatabase

func add_callbacks(trigger_block, data):
	if trigger_block is TriggerBlock_HasAlignmentRange:
		trigger_block.connect("alignment_range_changed", self, "on_character_alignment_range_changed", [data])

func remove_callbacks(trigger_block):
	if trigger_block is TriggerBlock_HasAlignmentRange:
		trigger_block.disconnect("alignment_range_changed", self, "on_character_alignment_range_changed")

func _init():
	quest_database = ResourceLoader.load("res://questie/quest-db.tres")

func on_character_alignment_range_changed(current_min, current_max, data):
	data.min_value = current_min
	data.max_value = current_max
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)
