tool
extends ScrollContainer

signal collect_block_requested()
signal kill_block_requested()
signal talk_block_requested()
signal go_to_block_requested()
signal interact_item_block_requested()
signal interact_character_block_requested()

var collect_button : Button
var kill_button : Button
var talk_button : Button
var go_to_button : Button
var interact_item_button : Button
var interact_character_button : Button

func _enter_tree():
    collect_button = $HBoxContainer/VBoxContainer/Button
    kill_button = $HBoxContainer/VBoxContainer2/Button
    talk_button = $HBoxContainer/VBoxContainer3/Button
    go_to_button = $HBoxContainer/VBoxContainer4/Button
    interact_item_button = $HBoxContainer/VBoxContainer5/Button
    interact_character_button = $HBoxContainer/VBoxContainer6/Button

    collect_button.connect("button_down", self, "on_collect_button_pressed")
    kill_button.connect("button_down", self, "on_kill_button_pressed")
    talk_button.connect("button_down", self, "on_talk_button_pressed")
    go_to_button.connect("button_down", self, "on_go_to_button_pressed")
    interact_item_button.connect("button_down", self, "on_interact_item_button_pressed")
    interact_character_button.connect("button_down", self, "on_interact_character_button_pressed")

func _exit_tree():
    collect_button.disconnect("button_down", self, "on_collect_button_pressed")
    kill_button.disconnect("button_down", self, "on_kill_button_pressed")
    talk_button.disconnect("button_down", self, "on_talk_button_pressed")
    go_to_button.disconnect("button_down", self, "on_go_to_button_pressed")
    interact_item_button.disconnect("button_down", self, "on_interact_item_button_pressed")
    interact_character_button.disconnect("button_down", self, "on_interact_character_button_pressed")

func on_collect_button_pressed():
    emit_signal("collect_block_requested")

func on_kill_button_pressed():
    emit_signal("kill_block_requested")

func on_talk_button_pressed():
    emit_signal("talk_block_requested")

func on_go_to_button_pressed():
    emit_signal("go_to_block_requested")

func on_interact_item_button_pressed():
    emit_signal("interact_item_block_requested")

func on_interact_character_button_pressed():
    emit_signal("interact_character_block_requested")