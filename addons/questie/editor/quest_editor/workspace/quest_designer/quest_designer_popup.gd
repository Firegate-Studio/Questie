tool
extends Panel
class_name QuestDesignerPopup

# called when a constraint button from the quest designer popup is pressed
signal constraint_block_requested(block)
# called when a trigger button from the quest designer popup is pressed
signal trigger_block_requested(block)
# called when a task button from the quest designer popup is pressed
signal task_block_requested(block)
# called when a reward button from the quest designer popup is pressed
signal reward_block_requested(block)

var constraint_blocks_container : ConstraintBlocksContainer
var trigger_blocks_container
var task_blocks_container
var reward_buttons_container 

func _enter_tree():
	constraint_blocks_container = $"VBoxContainer/Constraints Container"

	constraint_blocks_container.connect("has_item_block_requested", self, "on_has_item_constraint_requested")
	constraint_blocks_container.connect("is_location_block_requested", self, "on_is_location_constraint_requested")
	constraint_blocks_container.connect("alignment_block_requested", self, "on_alignment_constraint_requested")

func _exit_tree():
	constraint_blocks_container.disconnect("has_item_block_requested", self, "on_has_item_constraint_requested")
	constraint_blocks_container.disconnect("is_location_block_requested", self, "on_is_location_constraint_requested")
	constraint_blocks_container.disconnect("alignment_block_requested", self, "on_alignment_constraint_requested")

func on_has_item_constraint_requested():
	var block = ConstraintBlockBuilder.has_item_constraint()
	emit_signal("constraint_block_requested", block)

func on_is_location_constraint_requested():
	var block = ConstraintBlockBuilder.is_location_constraint()
	emit_signal("constraint_block_requested", block)

func on_alignment_constraint_requested():
	var block = ConstraintBlockBuilder.has_alignment_constraint()
	emit_signal("constraint_block_requested", block)
