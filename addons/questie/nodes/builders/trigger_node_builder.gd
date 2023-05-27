# generate all trigger nodes for the quest system
class_name TriggerNodeBuilder

static func get_item_node(trigger_data, trigger_id, quest_id, inventory)->TriggerNode:

	var node = load("res://addons/questie/nodes/triggers/get_item.gd").new()
	if not node:
		print("[Questie]: trigger node is not valid for trigger with identifier: " + trigger_id)
		return null

	# setup node
	node.id = trigger_id
	node.quest_id = quest_id
	node.inventory = inventory
	node.target_uuid = trigger_data.item_uuid

	return node

static func is_location_node(trigger_data, trigger_id, quest_id)->TriggerNode:
	
	var node = load("res://addons/questie/nodes/triggers/is_location.gd").new()
	if not node:
		print("[Questie]: trigger node is not valid for trigger with identifier: " + trigger_id)
		return null

	node.id = trigger_id
	node.quest_id = quest_id
	node.location_id = trigger_data.location_id
	node.category_id = trigger_data.category_id

	return node

static func item_interaction_node(trigger_data, trigger_id, quest_id)->TriggerNode:

	var node = load("res://addons/questie/nodes/triggers/item_interaction.gd").new()
	if not node:
		print("[Questie]: trigger node is not valid for trigger with identifier: " + trigger_id)
		return null

	node.id = trigger_id
	node.quest_id = quest_id
	node.item_id = trigger_data.item_id
	node.item_category = trigger_data.category
	return node

static func character_interaction_node(trigger_data, trigger_id, quest_id)->TriggerNode:

	var node = load("res://addons/questie/nodes/triggers/character_interaction.gd").new()
	if not node:
		print("[Questie]: trigger node is not valid for trigger with identifier: " + trigger_id)
		return null

	node.id = trigger_id
	node.quest_id = quest_id
	node.character_id = trigger_data.character_id
	return node
