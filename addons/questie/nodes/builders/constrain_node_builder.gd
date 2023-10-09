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
	node.item_uuid = constraint_data.item_id
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

static func is_location_node(constraint_data, constraint_id, quest_id)->Constraint: 
	var node = load("res://addons/questie/nodes/constraints/is_location.gd").new()
	if not node:
		print("[Questie]: constraint node is not valid for constraint with identifier: " + constraint_id)
		return null

	# setup constraint node
	node.id = constraint_id
	node.quest_id = quest_id
	node.location_id = constraint_data.location_id
	node.category_id = constraint_data.category_id

	return node

static func character_has_alignment_node(constraint_data, constraint_id, quest_id)->Constraint:
	var node = load("res://addons/questie/nodes/constraints/character_has_alignment.gd").new()
	if not node:
		print("[Questie]: constraint node is not valid for constraint with identifier: " + constraint_id)
		return null

	node.id = constraint_id
	node.quest_id = quest_id
	node.character_id = constraint_data.character_id
	node.min_alignment = constraint_data.min_alignment
	node.max_alignment = constraint_data.max_alignment

	return node

