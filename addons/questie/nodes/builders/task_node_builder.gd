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

	return node
