tool
extends GraphNode
class_name Block_QuestEdit

var quest_title : LineEdit
var quest_desc : TextEdit
var quest_alignment : SpinBox

# the quest database
var database : QuestDatabase

# the current quest data associeted with this block
var current_data : QuestData

# a list containing all blocks connected to the quest
var current_blocks : Array
# contains all identifiers for attached components such as constraint_data, trigger_data and so on.
var blocks_id_map : Dictionary = {}

# classes to attach and detach listeners in-from blocks when added or removed
var constraint_callbacks_handler : ConstraintCallbacksHandler
var trigger_callbacks_handler : TriggerCallbacksHandler
var task_callbacks_handler : TaskCallbacksHandler

func _enter_tree():

	database = preload("res://questie/quest-db.tres")

	quest_title = $HBoxContainer2/LineEdit
	quest_desc = $Description
	quest_alignment = $HBoxContainer/SpinBox

	constraint_callbacks_handler = ConstraintCallbacksHandler.new()
	trigger_callbacks_handler = TriggerCallbacksHandler.new()
	task_callbacks_handler = TaskCallbacksHandler.new()

	#todo: load information

	quest_title.connect("text_changed", self, "on_title_changed")
	quest_desc.connect("text_changed", self, "on_description_changed")
	quest_alignment.connect("value_changed", self, "on_alignment_changed")

func _ready():
	set_slot(3, true, 1, get_slot_color_left(3), false, -1, Color.coral)
	set_slot(4, true, 2, get_slot_color_left(4), false, -1, get_slot_color_right(4))
	set_slot(5, true, 3, get_slot_color_left(5), false, -1, get_slot_color_right(5))
	set_slot(6, true, 4, get_slot_color_left(6), false, -1, get_slot_color_right(6))

func _exit_tree():
	quest_title.disconnect("text_changed", self, "on_title_changed")
	quest_desc.disconnect("text_changed", self, "on_description_changed")
	quest_alignment.disconnect("value_changed", self, "on_alignment_changed")

func on_title_changed(new_text : String): 
	if not current_data:
		return

	current_data.title = new_text
	ResourceSaver.save("res://questie/quest-db.tres", database)
	print("[Questie]: set quest title to " + new_text + " for quest " + current_data.id)

func on_description_changed() : 
	if not current_data:
		return

	current_data.description = quest_desc.text
	ResourceSaver.save("res://questie/quest-db.tres", database)
	print("[Questie]: set quest description  to " + current_data.description + " for quest " + current_data.id)

func on_alignment_changed(alignment : float):
	if not current_data:
		return
	
	current_data.alignment = alignment
	ResourceSaver.save("res://questie/quest-db.tres", database)
	print("[Questie]: Set alignment to " + var2str(alignment) + " for quest " + current_data.id)

func setup(quest_data : QuestData):
	title = quest_data.item_name
	quest_title.text = quest_data.title
	quest_desc.text = quest_data.description
	quest_alignment.value = quest_data.alignment

	current_data = quest_data

# @brief                    add the constraint inside the quest database
# @param constriant_type    the type of constraint - see QuestData for further details
# @param block              the constraint block connecting to the quest
func add_constraint(constraint_type, block):
	match constraint_type:
		QuestData.ConstraintType.IS_LOCATION:
			var location_data = current_data.push_constraint(constraint_type, current_data.id)
			location_data.location_id =  block.current_location
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = location_data.uuid

			constraint_callbacks_handler.add_constraint_callbacks(block, location_data)
		
		QuestData.ConstraintType.HAS_ITEM:
			var constraint_data = current_data.push_constraint(constraint_type, current_data.id)
			constraint_data.item_id = block.selected_item_id
			constraint_data.quantity = block.current_quantity
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = constraint_data.uuid

			constraint_callbacks_handler.add_constraint_callbacks(block, constraint_data)

		QuestData.ConstraintType.HAS_ALIGNMENT:
			var constraint_data = current_data.push_constraint(constraint_type, current_data.id)
			constraint_data.min_alignment = block.current_min
			constraint_data.max_alignment = block.current_max
			constraint_data.character_id = block.selected_character_id
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = constraint_data.uuid

			constraint_callbacks_handler.add_constraint_callbacks(block, constraint_data)

# @brief 					add constraint data inside the quest database
# @param trigger_type		the trigger type
# @param block				the trigger block to add			
func add_trigger(trigger_type, block):
	match trigger_type:
		QuestData.TriggerType.ALIGNMENT_AMOUNT:
			var data = current_data.push_trigger(trigger_type, current_data.id)
			data.min_value = block.current_min
			data.max_value = block.current_max
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			trigger_callbacks_handler.add_callbacks(block, data)

		QuestData.TriggerType.ENTER_LOCATION:
			var data = current_data.push_trigger(trigger_type, current_data.id)
			data.location_id = block.selected_location_id
			data.location_index = block.selected_location_index
			data.category_index = block.selected_region_index
			data.category_id = block.selected_region_id
			data.character_index = block.selected_character_index
			data.character_id = block.selected_character_id
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			trigger_callbacks_handler.add_callbacks(block, data)

		QuestData.TriggerType.EXIT_LOCATION:
			var data = current_data.push_trigger(trigger_type, current_data.id)
			data.character_index = block.selected_character_index
			data.character_id = block.selected_character_id
			data.location_index = block.selected_location_index
			data.location_id = block.selected_location_id
			data.category_index = block.selected_region_index
			data.category_id = block.selected_region_id
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			trigger_callbacks_handler.add_callbacks(block, data)

		QuestData.TriggerType.GET_ITEM:
			var data = current_data.push_trigger(trigger_type, current_data.id)
			data.item_index = block.selected_item_index
			data.item_id = block.selected_item_id
			data.category_index = block.selected_item_index
			data.category_id = block.selected_item_id
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			trigger_callbacks_handler.add_callbacks(block, data)

		QuestData.TriggerType.INTERACT_CHARACTER:
			var data = current_data.push_trigger(trigger_type, current_data.id)
			data.character_idx = block.character_index 
			data.character_id = block.character_id
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			trigger_callbacks_handler.add_callbacks(block, data)

		QuestData.TriggerType.INTERACT_ITEM:
			var data = current_data.push_trigger(trigger_type, current_data.id)
			data.item_index = block.selected_item_index
			data.item_id = block.selected_item_id
			data.category_index = block.selected_category_index
			data.category_id = block.selected_category_id
			ResourceSaver.save("res://questie/quest-db.tres", database)


			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			trigger_callbacks_handler.add_callbacks(block, data)


# @brief 					add task data inside the quest database
# @param task_type			the task type
# @param block				the task block to add
func add_task(task_type, block):
	match task_type:
		QuestData.TaskType.ALIGNMENT_TARGET:
			# todo - ALIGNMENT_TARGET BLOCK
			pass

		QuestData.TaskType.COLLECT_ITEM:
			var data = current_data.push_task(task_type, current_data.id)
			data.category_index = block.selected_category_index
			data.category_id = block.selected_category_id
			data.item_index = block.selected_item_index
			data.item_id  = block.selected_item_id
			data.quantity = block.selected_quantity
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			task_callbacks_handler.add_callbacks(block, data)
		
		QuestData.TaskType.GO_TO:
			var data = current_data.push_task(task_type, current_data.id)
			data.category_index = block.selected_region_index
			data.category_id = block.selected_region_id
			data.location_index = block.selected_location_index
			data.location_id = block.selected_location_id
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			task_callbacks_handler.add_callbacks(block, data)

		QuestData.TaskType.INTERACT_CHARACTER:
			var data = current_data.push_task(task_type, current_data.id)
			data.character_idx = block.selected_character_index
			data.character_id = block.selected_character_id
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			task_callbacks_handler.add_callbacks(block, data)

		QuestData.TaskType.INTERACT_ITEM:
			var data = current_data.push_task(task_type, current_data.id)
			data.category_index = block.selected_category_index
			data.category_id = block.selected_category_id
			data.item_index = block.selected_item_index
			data.item_id = block.selected_item_id
			ResourceSaver.save("res://questie/quest-db.tres", database)

			current_blocks.append(block)
			blocks_id_map[block] = data.uuid

			task_callbacks_handler.add_callbacks(block, data)
			

		


# @brief                    remove the constraint from the database
# @param constraint_type    the type of constraint to remove - see QuestData for further details
# @param block              the constraint block disconnecting from the quest
func remove_constraint(constraint_type, block):
		var constraint_id = blocks_id_map[block]
		current_data.erase_constraint(constraint_id)
		ResourceSaver.save("res://questie/quest-db.tres", database)

		current_blocks.erase(block)
		blocks_id_map.erase(block)

		constraint_callbacks_handler.remove_constraint_callbacks(block) 

func remove_trigger(trigger_type, block):
		var trigger_id = blocks_id_map[block]
		current_data.erase_trigger(trigger_id)
		ResourceSaver.save("res://questie/quest-db.tres", database)

		current_blocks.erase(block)
		blocks_id_map.erase(block)

		trigger_callbacks_handler.remove_callbacks(block)

func remove_task(task_type, block):
	var task_id = blocks_id_map[block]
	current_data.erase_task(task_id)
	ResourceSaver.save("res://questie/quest-db.tres", database)

	current_blocks.erase(block)
	blocks_id_map.erase(block)

	task_callbacks_handler.remove_callbacks(block)


