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
var trigger_blocks_container : TriggerButtonsContainer
var task_blocks_container
var reward_buttons_container 

func _enter_tree():
	constraint_blocks_container = $"VBoxContainer/Constraints Container"
	trigger_blocks_container =$"VBoxContainer/Triggers Container"
	
	constraint_blocks_container.connect("has_item_block_requested", self, "on_has_item_constraint_requested")
	constraint_blocks_container.connect("is_location_block_requested", self, "on_is_location_constraint_requested")
	constraint_blocks_container.connect("alignment_block_requested", self, "on_alignment_constraint_requested")

	trigger_blocks_container.connect("alignment_amount_button_pressed", self, "on_alignment_trigger_requested")
	trigger_blocks_container.connect("enter_location_button_pressed", self, "on_enter_location_trigger_requested")
	trigger_blocks_container.connect("exit_location_button_pressed", self, "on_exit_location_trigger_requested")
	trigger_blocks_container.connect("interact_character_button_pressed", self, "on_interact_character_trigger_requested")
	trigger_blocks_container.connect("interact_item_button_pressed", self, "on_interact_item_trigger_requested")
	trigger_blocks_container.connect("get_item_button_pressed", self, "on_get_item_trigger_requested")

func _exit_tree():
	constraint_blocks_container.disconnect("has_item_block_requested", self, "on_has_item_constraint_requested")
	constraint_blocks_container.disconnect("is_location_block_requested", self, "on_is_location_constraint_requested")
	constraint_blocks_container.disconnect("alignment_block_requested", self, "on_alignment_constraint_requested")

	trigger_blocks_container.disconnect("alignment_amount_button_pressed", self, "on_alignment_trigger_requested")
	trigger_blocks_container.disconnect("enter_location_button_pressed", self, "on_enter_location_trigger_requested")
	trigger_blocks_container.disconnect("exit_location_button_pressed", self, "on_exit_location_trigger_requested")
	trigger_blocks_container.disconnect("interact_character_button_pressed", self, "on_interact_character_trigger_requested")
	trigger_blocks_container.disconnect("interact_item_button_pressed", self, "on_interact_item_trigger_requested")
	trigger_blocks_container.disconnect("get_item_button_pressed", self, "on_get_item_trigger_requested")


func on_has_item_constraint_requested():
	var block = ConstraintBlockBuilder.has_item_constraint()
	emit_signal("constraint_block_requested", block)

func on_is_location_constraint_requested():
	var block = ConstraintBlockBuilder.is_location_constraint()
	emit_signal("constraint_block_requested", block)

func on_alignment_constraint_requested():
	var block = ConstraintBlockBuilder.has_alignment_constraint()
	emit_signal("constraint_block_requested", block)


func on_alignment_trigger_requested():
	var block = TriggerBlockBuilder.alignment_amount()
	emit_signal("trigger_block_requested", block)

func on_enter_location_trigger_requested():
	var block = TriggerBlockBuilder.enter_location()
	emit_signal("trigger_block_requested", block)

func on_exit_location_trigger_requested():
	var block = TriggerBlockBuilder.exit_location()
	emit_signal("trigger_block_requested", block)

func on_interact_character_trigger_requested():
	var block = TriggerBlockBuilder.interact_character()
	emit_signal("trigger_block_requested", block)

func on_interact_item_trigger_requested():
	var block = TriggerBlockBuilder.interact_item()
	emit_signal("trigger_block_requested", block)

func on_get_item_trigger_requested():
	var block = TriggerBlockBuilder.get_item()
	emit_signal("trigger_block_requested", block)

