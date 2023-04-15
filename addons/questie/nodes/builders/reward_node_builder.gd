class_name RewardNodeBuilder

static func add_item_node(reward_data, reward_id, quest_id, player_inventory):
	var node = load("res://addons/questie/nodes/rewards/add_item.gd").new()
	if not node:
		print("[Questie]: reward node is not valid for reward with identifier: " + reward_id)
		return null

	# setup node
	node.id = reward_id
	node.quest_id = quest_id
	node.inventory = player_inventory
	node.item_id = reward_data.item_id
	node.item_quantity = reward_data.item_quantity

	return node

static func new_quest_node(reward_data, reward_id, quest_id):
	var node = load("res://addons/questie/nodes/rewards/new_quest.gd").new()
	if not node:
		print("[Questie]: reward node is not valid for reward with identifier: " + reward_id)
		return null

	# setup_node
	node.id = reward_id
	node.quest_id = quest_id
	node.target_quest_id = reward_data.quest_id

	return node


