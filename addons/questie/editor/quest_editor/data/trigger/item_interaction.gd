extends "res://addons/questie/editor/quest_editor/data/trigger/quest_trigger.gd"
class_name Trigger_ItemInteraction

# the identifier of the item to interact with
export(String) var item_id

# the category of the item
export(ItemsCollection.Categories) var category