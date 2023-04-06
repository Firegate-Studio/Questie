extends "res://addons/questie/editor/quest_editor/reward_data/quest_reward.gd"
class_name Reward_AddItem

# the id of the item to add
export(String) var item_id
# the category of the item to add
export(ItemDatabase.ItemCategory) var item_category = ItemDatabase.ItemCategory.WEAPON
# the quantity of the item to add
export(int) var item_quantity