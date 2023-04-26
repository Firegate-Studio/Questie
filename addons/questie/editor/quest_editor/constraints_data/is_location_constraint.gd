extends "res://addons/questie/editor/quest_editor/quest_constraint.gd"
class_name Constraint_IsLocation

# the category identifier of the location
export(String) var category_id

# the location identifier itself
export(String) var location_id 

# indices to get the right text from MenuButton
var category_index : int = -1
var location_index : int = -1