# generate all constraint nodes for runtime purposes
class_name ConstraintNodeBuilder

static func has_item_node(constraint_data, constraint_id, quest_id, inventory)->Constraint:

	var node = load("res://addons/questie/nodes/constraints/has_item.gd").new()
	if not node: 
		print("[Questie]: constraint node is not valid for constraint with identifier: " + constraint_id)
		return null

	# setup constraint node
	node.id = constraint_id
	node.quest_id = quest_id
	node.inventory = inventory
	node.item_uuid = constraint_data.item
	node.item_category = constraint_data.category
	node.item_quantity = constraint_data.quantity

	return node

static func quest_state_node(constraint_data, constraint_id, quest_id, quest)->Constraint:

	var node = load("res://addons/questie/nodes/constraints/quest_state.gd").new()
	if not node:
		print("[Questie]: constraint node is not valid for constraint with identifier: " + constraint_id)
		return null

	# setup constraint node
	node.id = constraint_id
	node.quest_id = quest_id
	node.target_state = constraint_data.state
	node.quest = quest

	return node

static func has_quest_node(constraint_data, constraint_id, quest_id, quest_node)->Constraint:

	var node = load("res://addons/questie/nodes/constraints/has_quest.gd").new()
	if not node:
		print("[Questie]: constraint node is not valid for constraint with identifier: " + constraint_id)
		return null

	# setup constraint node
	node.id = constraint_id
	node.quest_id = quest_id
	node.quest = quest_node

	return node

