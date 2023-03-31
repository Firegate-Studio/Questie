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
