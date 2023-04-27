extends "res://addons/questie/editor/quest_editor/data/constraint/quest_constraint.gd"
class_name Constraint_IsLocation

# the category identifier of the location
export(String) var category_id

# the location identifier itself
export(String) var location_id 

# indices to get the right text from MenuButton
export(int) var category_index : int
export(int) var location_index : int