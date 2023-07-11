extends "res://addons/questie/editor/quest_editor/data/reward/quest_reward.gd"
class_name Reward_AddItem

# the id of the item to add
export(String) var item_id
# the category of the item to add
export(ItemsCollection.Categories) var item_category
# the quantity of the item to add
export(int) var item_quantity
