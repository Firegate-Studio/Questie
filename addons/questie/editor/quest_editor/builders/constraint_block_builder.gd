tool
extends Object 
class_name ConstraintBlockBuilder

static func is_location_constraint():
	var block = load("res://addons/questie/editor/quest_editor/blocks/constraints/is_location.tscn").instance()
	if not block:
		print("[Questie]: unable to build is location constraint")
		return null

	return block
