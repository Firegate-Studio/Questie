tool
extends ScrollContainer
class_name ConstraintBlocksContainer

signal is_location_block_requested
signal has_item_block_requested
signal quest_state_block_requested
signal alignment_block_requested

var is_location : Button
var has_item : Button
var quest_state : Button
var alignment : Button

func _enter_tree():
	is_location =$"HBoxContainer/VBoxContainer/Button"
	has_item = $HBoxContainer/VBoxContainer2/Button
	quest_state = $HBoxContainer/VBoxContainer3/Button
	alignment = $HBoxContainer/VBoxContainer4/Button
	
	is_location.connect("button_down", self, "on_is_location_pressed")
	has_item.connect("button_down", self, "on_has_item_pressed")
	quest_state.connect("button_down", self, "on_quest_state_pressed")
	alignment.connect("button_down", self, "on_alignment_pressed")
	
func _exit_tree():
	is_location.disconnect("button_down", self, "on_is_location_pressed")
	has_item.disconnect("button_down", self, "on_has_item_pressed")
	quest_state.disconnect("button_down", self, "on_quest_state_pressed")
	alignment.disconnect("button_down", self, "on_alignment_pressed")
	
func on_is_location_pressed(): 
	emit_signal("is_location_block_requested")	

func on_has_item_pressed(): 
	emit_signal("has_item_block_requested")

func on_quest_state_pressed():
	emit_signal("quest_state_block_requested")

func on_alignment_pressed(): 
	emit_signal("alignment_block_requested")
