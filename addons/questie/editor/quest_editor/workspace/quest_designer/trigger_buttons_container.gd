tool
extends ScrollContainer
class_name TriggerButtonsContainer

signal alignment_amount_button_pressed()
signal enter_location_button_pressed()
signal exit_location_button_pressed()
signal get_item_button_pressed()
signal interact_character_button_pressed()
signal interact_item_button_pressed()

var alignment_amount_button : Button
var enter_location_button : Button
var exit_location_button : Button
var get_item_button : Button
var interact_character_button : Button
var interact_item_button : Button

func _enter_tree():
	enter_location_button = $HBoxContainer/VBoxContainer/Button
	exit_location_button = $HBoxContainer/VBoxContainer2/Button
	interact_item_button = $HBoxContainer/VBoxContainer3/Button
	interact_character_button = $HBoxContainer/VBoxContainer4/Button
	get_item_button = $HBoxContainer/VBoxContainer5/Button
	alignment_amount_button = $HBoxContainer/VBoxContainer6/Button

	enter_location_button.connect("button_down", self, "on_enter_location")
	exit_location_button.connect("button_down", self, "on_exit_location")
	interact_item_button.connect("button_down", self, "on_interact_item")
	interact_character_button.connect("button_down", self, "on_interact_character")
	get_item_button.connect("button_down", self, "on_get_item")
	alignment_amount_button.connect("button_down", self, "on_alignment")

func _exit_tree():
	enter_location_button.disconnect("button_down", self, "on_enter_location")
	exit_location_button.disconnect("button_down", self, "on_exit_location")
	interact_item_button.disconnect("button_down", self, "on_interact_item")
	interact_character_button.disconnect("button_down", self, "on_interact_character")
	get_item_button.disconnect("button_down", self, "on_get_item")
	alignment_amount_button.disconnect("button_down", self, "on_alignment")

func on_enter_location():           emit_signal("enter_location_button_pressed")
func on_exit_location():            emit_signal("exit_location_button_pressed")
func on_interact_item():            emit_signal("interact_item_button_pressed")
func on_interact_character():       emit_signal("interact_character_button_pressed")
func on_get_item():                 emit_signal("get_item_button_pressed")
func on_alignment():                emit_signal("alignment_amount_button_pressed")
