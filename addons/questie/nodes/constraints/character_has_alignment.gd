extends "res://addons/questie/nodes/constraints/constraint_node.gd"

# the identifier of the character to check
export(String) var character_id

# the minimum alignment value to bypass this constraint
export(float) var min_alignment

# the maximum alignment value to bypass this constraint
export(float) var max_alignment

var target_character : QuestieCharacter = null

func _enter_tree():

	# get character item
	var root = get_parent().get_parent().get_node("MasterScene")
	for child in root.get_children():
		
		#print("Analizing " + child.name)
		if not child is QuestieCharacter: continue

		if not child.get_id() == character_id: continue

		target_character = child
		print("[Questie]: alignment constraint recorded for " + target_character.name)

		QuestieEvents.connect("character_alignment_changed", self, "on_character_alignment_changed")
		break
		
func _exit_tree():
	var root = get_parent().get_parent()
	for child in root.get_children():

		if not child is QuestieCharacter: continue

		if not child.get_id() == character_id: continue

		QuestieEvents.disconnect("character_alignment_changed", self, "on_character_alignment_changed")
		break
		
func on_character_alignment_changed(_character_id, alignment):

	if not character_id == _character_id: return

	# the current character alignment
	alignment = target_character.get_alignment()
	
	# check if the constraint has been bypassed
	bypassed = alignment >= min_alignment and alignment <= max_alignment
	if bypassed:
		emit_signal("constraint_passed", id)
	else:
		emit_signal("constraint_failed", id)

   
