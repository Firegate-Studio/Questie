extends "res://addons/questie/editor/quest_editor/data/task/quest_task.gd"
class_name Task_ItemInteraction

# the item identifier for the item to interact
export(String) var item_id 

# the category of the item
export(ItemDatabase.ItemCategory) var category