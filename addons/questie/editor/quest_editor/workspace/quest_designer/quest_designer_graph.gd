tool
extends GraphEdit
class_name QuestDesignerGraph

var root_block : Block_QuestEdit
var quest_database : QuestDatabase
var popup : QuestDesignerPopup

# the current quest data associeted with this block
var current_data : QuestData

# blocks
var constraint_blocks : Array
var trigger_blocks : Array
var task_blocks : Array
var reward_blocks : Array

# where to spawn a popup or a new block
var spawn_point : Vector2

func _enter_tree(): 

	quest_database = load("res://questie/quest-db.tres")
	init_quest_block()
	init_popup()

	add_valid_connection_type(1,1)

	connect("connection_to_empty", self, "on_connection_to_empty")
	connect("connection_from_empty", self, "on_connection_from_empty")
	connect("connection_request", self, "on_connection_request")
	connect("disconnection_request", self, "on_disconnection_request")
	connect("popup_request", self, "on_popup_request")

	# popup signals
	popup.connect("constraint_block_requested", self, "on_block_creation")
	popup.connect("trigger_block_requested", self, "on_block_creation")
	popup.connect("task_block_requested", self, "on_block_creation")
	popup.connect("reward_block_requested", self, "on_block_creation")


func _exit_tree(): 
	disconnect("connection_to_empty", self, "on_connection_to_empty")
	disconnect("connection_from_empty", self, "on_connection_from_empty")
	disconnect("connection_request", self, "on_connection_request")
	disconnect("disconnection_request", self, "on_disconnection_request")
	disconnect("popup_request", self, "on_popup_request")

	# popup signals
	popup.disconnect("constraint_block_requested", self, "on_block_creation")
	popup.disconnect("trigger_block_requested", self, "on_block_creation")
	popup.disconnect("task_block_requested", self, "on_block_creation")
	popup.disconnect("reward_block_requested", self, "on_block_creation")


func on_connection_to_empty(from : String, from_slot: int, release_position : Vector2): 
	print("[Questie]: called connection to empty")

func on_connection_from_empty(to : String, to_slot : int, release_position : Vector2):
	print("[Questie]: called connection from empty")

func on_connection_request(from : String, from_slot : int, to : String, to_slot : int):
	print("[Questie]: attempting connection " + from + "(" + var2str(from_slot) + ") to " + to + "(" + var2str(to_slot) + ")")

	if is_node_connected(from, from_slot, to, to_slot):
		print("[Questie]: already connected")
		return

	var block = get_node(from)
	if not block:
		print("[Questie]: can not identify block to attempt connection")
		return

	if not is_valid_block(block):
		print("[Questie]: the block [" + from + "] has not been identified")
		return
	
	# identify block type
	if is_constraint_block(block):
		root_block.add_constraint(get_block_type(block), block)
	if is_trigger_block(block):
		root_block.add_trigger(get_block_type(block), block)
	if is_task_block(block):
		root_block.add_task(get_block_type(block), block)
	if is_reward_block(block):
		root_block.add_reward(get_block_type(block), block)

	# todo: save quest database
	connect_node(from, from_slot, to, to_slot)
	print("[Questie]: connected!")

func on_disconnection_request(from : String, from_port : int, to : String, to_port : int):
	print("[Questie]: attempting disconnection " + from + "(" + var2str(from_port) + ") to " + to + "(" + var2str(to_port) + ")")

	var block = get_node(from)
	if not block:
		print("[Questie]: can not identify block to attempt disconnection")
		return

	if not is_valid_block(block):
		print("[Questie]: the block [" + from + "] has not been identified")
		return

	# identify block
	if is_constraint_block(block): 
		root_block.remove_constraint(get_block_type(block), block)
	if is_trigger_block(block): 
		root_block.remove_trigger(get_block_type(block), block)
	if is_task_block(block):
		root_block.remove_task(get_block_type(block), block)
	if is_reward_block(block):
		root_block.remove_reward(get_block_type(block), block)

	disconnect_node(from, from_port, to, to_port)
	print("[Questie]: disconnected!")

func on_popup_request(position : Vector2): 
	print("[Questie]: popup requested...")
	
	popup.set_global_position(position)
	spawn_point = position
	popup.show()

func on_block_creation(block):
	add_child(block)

	if is_constraint_block(block):
		constraint_blocks.append(block)
	if is_trigger_block(block):
		trigger_blocks.append(block)
	if is_task_block(block):
		task_blocks.append(block)
	if is_reward_block(block):
		reward_blocks.append(block)

	block.rect_position += spawn_point
	block.connect("close_request", self, "on_block_deletion_requested", [block])

	popup.hide()

#	QuestDesignerSaver.save(current_data.id, get_children())

func on_block_deletion_requested(block):

	# check if the block is connected to the quest block and disconnect 
	var connections = get_connection_list()
	for connection in connections:
		if not connection["from"] == block.name: continue
		
		# store data
		var from  = connection["from"]
		var from_port = connection["from_port"]
		var to = connection["to"]
		var to_port = connection["to_port"]
		
		disconnect_node(from, from_port, to, to_port)
		if is_constraint_block(block): root_block.remove_constraint(get_block_type(block), block)
		if is_trigger_block(block): root_block.remove_trigger(get_block_type(block), block)
		if is_task_block(block): root_block.remove_task(get_block_type(block), block)
		if is_reward_block(block): root_block.remove_reward(get_block_type(block), block)
		break

	if constraint_blocks.has(block): constraint_blocks.erase(block)
	if trigger_blocks.has(block): trigger_blocks.erase(block)
	if task_blocks.has(block): task_blocks.erase(block)
	if reward_blocks.has(block): reward_blocks.erase(block)	

	remove_child(block)
	block.queue_free()
	
	

func init_quest_block():
	root_block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/quest_edit_block.tscn").instance()
	if not root_block:
		print("[Questie]: can't initialize quest block!")
		return

	root_block.offset += Vector2(600,350)
	add_child(root_block)

func init_popup():
	popup = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/QuestDesignerPopup.tscn").instance()
	if not popup:
		print("[Questie]: can not load quest designer popup!")
		return
	
	add_child(popup)
	popup.hide()

# @brief                    initialize blocks and connections inside the graph
# @param quest_id           the quest identifier 
func setup(quest_id : String):
	if not quest_database:
		print("[Questie]: invalid quest database for QuestBuilderGraph")
		return

	var data = quest_database.get_quest_data(quest_id)
	if not data:
		print("[Questie]: invalid quest data for quest " + quest_id)

	root_block.setup(data)

	clear_viewport()
	
	var count : int = 0
	count = load_constraint_blocks(data, count)
	count = load_trigger_blocks(data, count)
	count = load_task_blocks(data, count)
	count = load_reward_blocks(data, count)

func is_valid_block(block): 
	return constraint_blocks.has(block) or trigger_blocks.has(block) or task_blocks.has(block) or reward_blocks.has(block)

func get_block_type(block):
	if block is ConstraintBlock_IsLocation:
		return QuestData.ConstraintType.IS_LOCATION
	if block is ConstraintBlock_HasAlignment:
		return QuestData.ConstraintType.HAS_ALIGNMENT
	if block is ConstraintBlock_HasItem:
		return QuestData.ConstraintType.HAS_ITEM
	
	if block is TriggerBlock_CharacterEnterLocation:
		return QuestData.TriggerType.ENTER_LOCATION
	if block is TriggerBlock_CharacterExitLocation:
		return QuestData.TriggerType.EXIT_LOCATION
	if block is TriggerBlock_GetItem:
		return QuestData.TriggerType.GET_ITEM
	if block is TriggerBlock_HasAlignmentRange:
		return QuestData.TriggerType.ALIGNMENT_AMOUNT
	if block is TriggerBlock_InteractCharacter:
		return QuestData.TriggerType.INTERACT_CHARACTER
	if block is TriggerBlock_InteractItem:
		return QuestData.TriggerType.INTERACT_ITEM

	if block is TaskBlock_AlignmentRange:
		return QuestData.TaskType.ALIGNMENT_TARGET
	if block is TaskBlock_Collect:
		return QuestData.TaskType.COLLECT_ITEM
	if block is TaskBlock_GoTo:
		return QuestData.TaskType.GO_TO
	if block is TaskBlock_InteractCharacter:
		return QuestData.TaskType.INTERACT_CHARACTER
	if block is TaskBlock_InteractItem:
		return QuestData.TaskType.INTERACT_ITEM
	if block is TaskBlock_Kill:
		return QuestData.TaskType.KILL
	if block is TaskBlock_Talk:
		return QuestData.TaskType.TALK

	if block is RewardBlock_AddAlignment:
		return QuestData.RewardType.ADD_ALIGNMENT
	if block is RewardBlock_AddItem:
		return QuestData.RewardType.ADD_ITEM

func is_constraint_block(block): return block is ConstraintBlock_HasAlignment or block is ConstraintBlock_HasItem or block is ConstraintBlock_IsLocation

func is_trigger_block(block): return block is TriggerBlock_CharacterEnterLocation or block is TriggerBlock_CharacterExitLocation or block is TriggerBlock_GetItem or block is TriggerBlock_HasAlignmentRange or block is TriggerBlock_InteractCharacter or block is TriggerBlock_InteractItem

func is_task_block(block): return block is TaskBlock_AlignmentRange or block is TaskBlock_Collect or block is TaskBlock_GoTo or block is TaskBlock_InteractCharacter or block is TaskBlock_InteractItem or block is TaskBlock_Kill or block is TaskBlock_Talk

func is_reward_block(block): return block is RewardBlock_AddAlignment or block is RewardBlock_AddItem

func clear_viewport():
	for block in get_children():
		if is_constraint_block(block):
			disconnect_node(block.name, 0, root_block.name, 0)
			root_block.constraint_callbacks_handler.remove_constraint_callbacks(block)
			block.queue_free()
		if is_trigger_block(block):
			disconnect_node(block.name, 0, root_block.name, 1)
			root_block.trigger_callbacks_handler.remove_callbacks(block)
			block.queue_free()
		if is_task_block(block):
			disconnect_node(block.name, 0, root_block.name, 2)
			root_block.task_callbacks_handler.remove_callbacks(block)
			block.queue_free()
		if is_reward_block(block):
			disconnect_node(block.name, 0, root_block.name, 3)
			root_block.reward_callabcks_handler.remove_callbacks(block)
			block.queue_free()

func load_constraint_blocks(quest_data : QuestData, count : int = 0, snap : float = 120):
	
	var item_db : ItemDatabase = ResourceLoader.load("res://questie/item-db.tres")
	var location_db : LocationDatabase = ResourceLoader.load("res://questie/location-db.tres")
	var characters_db : CharacterDatabase = ResourceLoader.load("res://questie/characters-db.tres")
	
	for constraint_data in quest_data.constraints:
		count += 1
		if constraint_data is Constraint_HasAlignment:
			var block : ConstraintBlock_HasAlignment = ConstraintBlockBuilder.has_alignment_constraint()
			add_child(block)
			block.current_min = constraint_data.min_alignment
			block.current_max = constraint_data.max_alignment
			block.min_alignment.value = constraint_data.min_alignment
			block.max_alignment.value = constraint_data.max_alignment
			block.characters_menu.text = characters_db.get_character_data(constraint_data.character_id).title
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 0)
			constraint_blocks.append(block)
			root_block.blocks_id_map[block] = constraint_data.uuid
			root_block.constraint_callbacks_handler.add_constraint_callbacks(block, constraint_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue
		if constraint_data is Constraint_HasItem:
			var block : ConstraintBlock_HasItem  = ConstraintBlockBuilder.has_item_constraint()
			add_child(block)
			block.item_name.text = item_db.get_item(constraint_data.item_id).name
			block.item_quantity.value = constraint_data.quantity
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 0)
			constraint_blocks.append(block)
			root_block.blocks_id_map[block] = constraint_data.uuid
			root_block.constraint_callbacks_handler.add_constraint_callbacks(block, constraint_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue
		if constraint_data is Constraint_IsLocation:
			var block : ConstraintBlock_IsLocation = ConstraintBlockBuilder.is_location_constraint()
			add_child(block)
			block.location_menu.text = location_db.locations[constraint_data.location_index].name
			block.current_location_id = constraint_data.location_id
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 0)
			constraint_blocks.append(block)
			root_block.blocks_id_map[block] = constraint_data.uuid
			root_block.constraint_callbacks_handler.add_constraint_callbacks(block, constraint_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue
	return count

func load_trigger_blocks(quest_data : QuestData, count : int = 0, snap : float = 120):
	
	var character_db : CharacterDatabase = ResourceLoader.load("res://questie/characters-db.tres")
	var location_db : LocationDatabase = ResourceLoader.load("res://questie/location-db.tres")
	var item_db : ItemDatabase = ResourceLoader.load("res://questie/item-db.tres")

	for trigger_data in quest_data.triggers:
		count += 1
		if trigger_data is Trigger_AlignmentAmount: 
			var block : TriggerBlock_HasAlignmentRange = TriggerBlockBuilder.alignment_amount()
			add_child(block)
			block.current_min = trigger_data.min_value
			block.current_max = trigger_data.max_value
			block.min_alignment_spin.value = trigger_data.min_value
			block.max_alignment_spin.value = trigger_data.max_value 
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 1)
			trigger_blocks.append(block)
			root_block.blocks_id_map[block] = trigger_data.uuid
			root_block.trigger_callbacks_handler.add_callbacks(block, trigger_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue
		if trigger_data is Trigger_CharacterInteraction: 
			var block : TriggerBlock_InteractCharacter = TriggerBlockBuilder.interact_character()
			add_child(block)
			block.character_menu.text = character_db.get_character_data(trigger_data.character_id).title
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 1)
			trigger_blocks.append(block)
			root_block.blocks_id_map[block] = trigger_data.uuid
			root_block.trigger_callbacks_handler.add_callbacks(block, trigger_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue
		if trigger_data is Trigger_EnterLocation: 
			var block : TriggerBlock_CharacterEnterLocation = TriggerBlockBuilder.enter_location()
			add_child(block)
			block.region_name.text = location_db.get_category(trigger_data.category_id).title
			block.location_name.text = location_db.locations[trigger_data.location_index].name
			block.character_menu.text = character_db.get_character_data(trigger_data.character_id).title
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 1)
			trigger_blocks.append(block)
			root_block.blocks_id_map[block] = trigger_data.uuid
			root_block.trigger_callbacks_handler.add_callbacks(block, trigger_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue
		if trigger_data is Trigger_ExitLocation: 
			var block : TriggerBlock_CharacterExitLocation = TriggerBlockBuilder.exit_location()
			add_child(block)
			block.character_menu.text = character_db.get_character_data(trigger_data.character_id).title
			block.region_name.text = location_db.get_category(trigger_data.category_id).title
			block.location_name.text = location_db.locations[trigger_data.location_index].name
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 1)
			trigger_blocks.append(block)
			root_block.blocks_id_map[block] = trigger_data.uuid
			root_block.trigger_callbacks_handler.add_callbacks(block, trigger_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue
		if trigger_data is Trigger_GetItem:
			var block : TriggerBlock_GetItem = TriggerBlockBuilder.get_item()
			add_child(block)
			block.selected_item_category_index = trigger_data.category_index
			block.selected_item_category_id = trigger_data.category_id
			block.selected_item_index = trigger_data.item_index
			block.selected_item_id = trigger_data.item_id
			block.category_menu.text = item_db.get_category(trigger_data.category_id).name
			block.item_menu.text = item_db.get_item(trigger_data.item_id).name
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 1)
			trigger_blocks.append(block)
			root_block.blocks_id_map[block] = trigger_data.uuid
			root_block.trigger_callbacks_handler.add_callbacks(block, trigger_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue
		if trigger_data is Trigger_ItemInteraction: 
			var block : TriggerBlock_InteractItem = TriggerBlockBuilder.interact_item()
			add_child(block)
			block.selected_category_index = trigger_data.category_index
			block.selected_category_id = trigger_data.category_id
			block.selected_item_index = trigger_data.item_index
			block.selected_item_id = trigger_data.item_id
			block.category_menu.text = item_db.get_category(trigger_data.category_id).name
			block.item_menu.text = item_db.get_item(trigger_data.item_id).name
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 1)
			trigger_blocks.append(block)
			root_block.blocks_id_map[block] = trigger_data.uuid
			root_block.trigger_callbacks_handler.add_callbacks(block, trigger_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue

	return count

func load_task_blocks(quest_data : QuestData, count : int = 0, snap : float = 120):
	
	var item_db : ItemDatabase = ResourceLoader.load("res://questie/item-db.tres")
	var location_db : LocationDatabase = ResourceLoader.load("res://questie/location-db.tres")
	var character_db : CharacterDatabase = ResourceLoader.load("res://questie/characters-db.tres")

	for task_data in quest_data.tasks:
		count += 1
		if task_data is Task_AlignmentRange: 
			var block : TaskBlock_AlignmentRange = TaskBlockBuilder.alignment_range()
			add_child(block)
			block.current_min_alignment = task_data.min_value
			block.current_max_alignment = task_data.max_value
			block.min_box.value = task_data.min_value
			block.max_box.value = task_data.max_value
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 2)
			task_blocks.append(block)
			root_block.blocks_id_map[block] = task_data.uuid
			root_block.task_callbacks_handler.add_callbacks(block, task_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue

		if task_data is Task_CharacterInteraction: 
			var block : TaskBlock_InteractCharacter = TaskBlockBuilder.interact_character()
			add_child(block)
			block.selected_character_index = task_data.character_idx
			block.selected_character_id = task_data.character_id
			block.character_menu.text = character_db.get_character_data(task_data.character_id).title
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 2)
			task_blocks.append(block)
			root_block.blocks_id_map[block] = task_data.uuid
			root_block.task_callbacks_handler.add_callbacks(block, task_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue

		if task_data is Task_CollectItem: 
			var block : TaskBlock_Collect = TaskBlockBuilder.collect()
			add_child(block)
			block.selected_category_index = task_data.category_id
			block.selected_category_id = task_data.category_id
			block.selected_item_index = task_data.item_index
			block.selected_item_id = task_data.item_id
			block.selected_quantity = task_data.quantity
			block.category_menu.text = item_db.get_category(task_data.category_id).name
			block.item_menu.text = item_db.get_item(task_data.item_id).name
			block.quantityBox.value = task_data.quantity
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 2)
			task_blocks.append(block)
			root_block.blocks_id_map[block] = task_data.uuid
			root_block.task_callbacks_handler.add_callbacks(block, task_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue

		if task_data is Task_GoTo: 
			var block : TaskBlock_GoTo = TaskBlockBuilder.go_to()
			add_child(block)
			block.selected_region_index = task_data.category_index
			block.selected_region_id = task_data.category_id
			block.selected_location_index = task_data.location_index
			block.selected_location_id = task_data.location_id
			block.region_menu.text = location_db.get_category(task_data.category_id).title
			block.location_menu.text = location_db.locations[task_data.location_index].name
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 2)
			task_blocks.append(block)
			root_block.blocks_id_map[block] = task_data.uuid
			root_block.task_callbacks_handler.add_callbacks(block, task_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue
		
		if task_data is Task_ItemInteraction: 
			var block : TaskBlock_InteractItem = TaskBlockBuilder.interact_item()
			add_child(block)
			block.selected_category_index = task_data.category_index
			block.selected_category_id = task_data.category_id
			block.selected_item_index = task_data.item_index
			block.selected_item_id = task_data.item_id
			block.category_menu.text = item_db.get_category(task_data.category_id).name
			block.item_menu.text = item_db.get_item(task_data.item_id).name
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 2)
			task_blocks.append(block)
			root_block.blocks_id_map[block] = task_data.uuid
			root_block.task_callbacks_handler.add_callbacks(block, task_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue

		if task_data is Task_Kill: 
			var block : TaskBlock_Kill = TaskBlockBuilder.kill()
			add_child(block)
			block.selected_character_index = task_data.character_index
			block.selected_character_id = task_data.character_id
			block.selected_quantity = task_data.target_kills
			block.character_menu.text = character_db.get_character_data(task_data.character_id).title
			block.quantity_box.value = task_data.target_kills
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 2)
			task_blocks.append(block)
			root_block.blocks_id_map[block] = task_data.uuid
			root_block.task_callbacks_handler.add_callbacks(block, task_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue

		if task_data is Task_TalkTo: 
			var block : TaskBlock_Talk = TaskBlockBuilder.talk()
			add_child(block)
			block.selected_character_index = task_data.character_index
			block.selected_character_id = task_data.character_id
			block.character_menu.text = character_db.get_character_data(task_data.character_id).title
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 2)
			task_blocks.append(block)
			root_block.blocks_id_map[block] = task_data.uuid
			root_block.task_callbacks_handler.add_callbacks(block, task_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue

	return count

func load_reward_blocks(quest_data : QuestData, count : int = 0, snap : float = 120):
	
	var item_db : ItemDatabase = ResourceLoader.load("res://questie/item-db.tres")

	for reward_data in quest_data.rewards:
		count += 1
		
		if reward_data is RewardData_AddAlignment:
			var block : RewardBlock_AddAlignment = RewardBlockBuilder.add_alignment()
			add_child(block)
			block.alignment_amount = reward_data.alignment_amount
			block.alignment_box.value = reward_data.alignment_amount
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 3)
			reward_blocks.append(block)
			root_block.blocks_id_map[block] = reward_data.uuid
			root_block.reward_callabcks_handler.add_callbacks(block, reward_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue

		if reward_data is Reward_AddItem:
			var block : RewardBlock_AddItem = RewardBlockBuilder.add_item()
			add_child(block)
			block.current_quantity = reward_data.item_quantity
			block.selected_category_index = reward_data.category_index
			block.selected_category_id = reward_data.category_id
			block.selected_item_index = reward_data.item_index
			block.selected_item_id = reward_data.item_id
			block.category_menu.text = item_db.get_category(reward_data.category_id).name
			block.item_menu.text = item_db.get_item(reward_data.item_id).name
			block.quantity_box.value = reward_data.item_quantity
			block.offset = Vector2(block.offset.x, count * snap)
			connect_node(block.name, 0, root_block.name, 3)
			reward_blocks.append(block)
			root_block.blocks_id_map[block] = reward_data.uuid
			root_block.reward_callabcks_handler.add_callbacks(block, reward_data)
			block.connect("close_request", self, "on_block_deletion_requested", [block])
			continue

	return count
