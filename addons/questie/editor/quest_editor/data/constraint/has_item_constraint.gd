extends "res://addons/questie/editor/quest_editor/data/constraint/quest_constraint.gd"
class_name Constraint_HasItem

# the item identifier
export(String) var item_id

# The item category (i.e., Weapon, Armor, Consumable,..., etc.)
export(int) var category = 0

# The item quantity
export(int) var quantity = 1
