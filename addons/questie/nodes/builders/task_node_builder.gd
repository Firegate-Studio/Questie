class_name TaskNodeBuilder

static func collect_item_node(task_data, task_id, quest_id, inventory)->TaskNode:

	var node = load("res://addons/questie/nodes/tasks/collect_item.gd").new()
	if not node:
		print("[questie]: task generation failed for task with identifier: " + task_id)
		return null

	# setup node
	node.id = task_id
	node.quest_id = quest_id
	node.inventory = inventory
	node.item_id = task_data.item_uuid
	node.item_quantity = task_data.quantity

	return node

static func go_to_node(task_data, task_id, quest_id)->TaskNode:
	
	var node = load("res://addons/questie/nodes/tasks/go_to.gd").new()
	if not node:
		print("[Questie]: task generation failed for task with identifier: " + task_id)
		return null

	#setup node
	node.id = task_id
	node.quest_id = quest_id
	node.location_id = task_data.location_id
	node.category_id = task_data.category_id

	return node

static func item_interaction_node(task_data, task_id, quest_id)->TaskNode:

	var node = load("res://addons/questie/nodes/tasks/item_interaction.gd").new()
	if not node:
		print("[Questie]: task generation failed for task with identifier: " + task_id)
		return null

	#setup node
	node.id = task_id
	node.quest_id = quest_id
	node.item_id = task_data.item_id
	return node

static func character_interaction_node(task_data, task_id, quest_id)->TaskNode:

	var node = load("res://addons/questie/nodes/tasks/character_interaction.gd").new()
	if not node:
		print("[Questie]: task generation failed for task with identifier: " + task_id)
		return null

	#setup node
	node.id = task_id
	node.quest_id = quest_id
	node.character_id = task_data.character_id
	return node
		
static func talk_to_node(task_data, task_id, quest_id)->TaskNode:

	var node = load("res://addons/questie/nodes/tasks/talk_to.gd").new()
	if not node:
		print("[Questie]: task generation failed for task with identifier: " + task_id)
		return null

	#setup node
	node.id = task_id
	node.quest_id = quest_id
	node.character_id = task_data.character_id
	return node

static func kill_node(task_data, task_id, quest_id)->TaskNode:
	
	var node = load("res://addons/questie/nodes/tasks/kill.gd").new()
	if not node:
		print("[Questie]: task generation failed for task with identifier: " + task_id)
		return null

	# setup node
	node.id = task_id
	node.quest_id = quest_id
	node.character_id = task_data.character_id
	node.target_kills = task_data.target_kills
	return node