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
var reward_buttons_container  : RewardButtonsContainer

func _enter_tree():
	constraint_blocks_container = $"VBoxContainer/Constraints Container"
	trigger_blocks_container =$"VBoxContainer/Triggers Container"
	task_blocks_container = $"VBoxContainer/Tasks Container"
	reward_buttons_container = $"VBoxContainer/Rewards Container"
	
	constraint_blocks_container.connect("has_item_block_requested", self, "on_has_item_constraint_requested")
	constraint_blocks_container.connect("is_location_block_requested", self, "on_is_location_constraint_requested")
	constraint_blocks_container.connect("alignment_block_requested", self, "on_alignment_constraint_requested")

	trigger_blocks_container.connect("alignment_amount_button_pressed", self, "on_alignment_trigger_requested")
	trigger_blocks_container.connect("enter_location_button_pressed", self, "on_enter_location_trigger_requested")
	trigger_blocks_container.connect("exit_location_button_pressed", self, "on_exit_location_trigger_requested")
	trigger_blocks_container.connect("interact_character_button_pressed", self, "on_interact_character_trigger_requested")
	trigger_blocks_container.connect("interact_item_button_pressed", self, "on_interact_item_trigger_requested")
	trigger_blocks_container.connect("get_item_button_pressed", self, "on_get_item_trigger_requested")

	task_blocks_container.connect("alignment_button_requested", self, "on_alignment_task_requested")
	task_blocks_container.connect("collect_block_requested", self, "on_collect_task_requested")
	task_blocks_container.connect("go_to_block_requested", self, "on_go_to_task_requested")
	task_blocks_container.connect("kill_block_requested", self, "on_kill_task_requested")
	task_blocks_container.connect("talk_block_requested", self, "on_talk_task_requested")
	task_blocks_container.connect("interact_item_block_requested", self, "on_interact_item_task_requested")
	task_blocks_container.connect("interact_character_block_requested", self, "on_interact_character_task_requested")

	reward_buttons_container.connect("add_item_block_requested", self, "on_add_item_reward_requested")
	reward_buttons_container.connect("add_alignment_block_requested", self, "on_add_alignment_reward_requested")

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

	task_blocks_container.disconnect("alignment_button_requested", self, "on_alignment_button_requested")
	task_blocks_container.disconnect("collect_block_requested", self, "on_collect_task_requested")
	task_blocks_container.disconnect("go_to_block_requested", self, "on_go_to_task_requested")
	task_blocks_container.disconnect("kill_block_requested", self, "on_kill_task_requested")
	task_blocks_container.disconnect("talk_block_requested", self, "on_talk_task_requested")
	task_blocks_container.disconnect("interact_item_block_requested", self, "on_interact_item_task_requested")
	task_blocks_container.disconnect("interact_character_block_requested", self, "on_interact_character_task_requested")

	reward_buttons_container.disconnect("add_item_block_requested", self, "on_add_item_reward_requested")
	reward_buttons_container.disconnect("add_alignment_block_requested", self, "on_add_alignment_reward_requested")


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


func on_alignment_task_requested():
	var block = TaskBlockBuilder.alignment_range()
	emit_signal("task_block_requested", block)

func on_collect_task_requested():
	var block = TaskBlockBuilder.collect()
	emit_signal("task_block_requested", block)

func on_go_to_task_requested():
	var block = TaskBlockBuilder.go_to()
	emit_signal("task_block_requested", block)

func on_kill_task_requested():
	var block = TaskBlockBuilder.kill()
	emit_signal("task_block_requested", block)

func on_talk_task_requested():
	var block = TaskBlockBuilder.talk()
	emit_signal("task_block_requested", block)

func on_interact_item_task_requested():
	var block = TaskBlockBuilder.interact_item()
	emit_signal("task_block_requested", block)

func on_interact_character_task_requested():
	var block = TaskBlockBuilder.interact_character()
	emit_signal("task_block_requested", block)

func on_add_item_reward_requested():
	var block = RewardBlockBuilder.add_item()
	emit_signal("reward_block_requested", block)

func on_add_alignment_reward_requested():
	var block = RewardBlockBuilder.add_alignment()
	emit_signal("reward_block_requested", block)


