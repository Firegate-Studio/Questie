class_name Trigger_GetItem
extends "res://addons/questie/editor/quest_editor/trigger_data/quest_trigger.gd"

# The uuid of the item to track into player inventory
export(String) var item_uuid

# The category of the tracked item
export(ItemDatabase.ItemCategory) var item_category

