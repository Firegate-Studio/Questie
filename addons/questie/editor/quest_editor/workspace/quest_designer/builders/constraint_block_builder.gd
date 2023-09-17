tool
extends Object 
class_name ConstraintBlockBuilder

static func is_location_constraint():
	var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/constraints/is_location.tscn").instance()
	if not block:
		print("[Questie]: unable to build is location constraint")
		return null

	return block

static func has_alignment_constraint():
	var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/constraints/has_alignment.tscn").instance()
	if not block:
		print("[Questie]: unable to build has alignment constraint")
		return null

	return block

static func has_item_constraint():
	var block = load("res://addons/questie/editor/quest_editor/workspace/quest_designer/blocks/constraints/has_item.tscn").instance()
	if not block:
		print("[Questie]: unable to build has item constraint")
		return null

	return block
