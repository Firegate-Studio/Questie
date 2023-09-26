tool
extends ScrollContainer
class_name RewardButtonsContainer 

signal add_item_block_requested()
signal add_alignment_block_requested()

var add_item_button : Button
var add_alignment_button : Button

func _enter_tree(): 
    add_item_button = $HBoxContainer/VBoxContainer/Button
    add_alignment_button = $HBoxContainer/VBoxContainer2/Button

    add_item_button.connect("button_down", self, "on_add_item_button_pressed")
    add_alignment_button.connect("button_down", self, "on_add_alignment_button_pressed")

func _exit_tree(): 
    add_item_button.disconnect("button_down", self, "on_add_item_button_pressed")
    add_alignment_button.disconnect("button_down", self, "on_add_alignment_button_pressed")

func on_add_item_button_pressed():
    emit_signal("add_item_block_requested")

func on_add_alignment_button_pressed():
    emit_signal("add_alignment_block_requested")