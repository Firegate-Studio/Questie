tool
extends Control

signal has_item_request()
signal has_quest_request()
signal quest_state_request()

var constraint_has_item : Button
var constraint_has_quest : Button
var constraint_quest_state : Button

var trigger_area_bounds : Button
var trigger_get_item : Button

var task_collect : Button
var task_fetch : Button
var task_kill : Button

func constraint_has_item_pressed(): 
	print("[questie]: has item contraint requested")
	emit_signal("has_item_request")

func constraint_has_quest_pressed(): 
	print("[questie]: has item constraint requested")
	emit_signal("has_quest_request")

func constraint_quest_state_pressed(): 
	print("[questie]: quest state constraint requested")

func trigger_area_bounds_pressed(): 
	print("[questie]: area bounds trigger requested")

func trigger_get_item_pressed():
	print("[questie]: collect item trigger requested")

func _enter_tree():

	# Get references from interface
	constraint_has_item = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/has item block"
	constraint_has_quest = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/has quest block"
	constraint_quest_state = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/state quest block"

	constraint_has_item.connect("button_down", self, "constraint_has_item_pressed")
	constraint_has_quest.connect("button_down", self, "constraint_has_quest_pressed")
	constraint_quest_state.connect("button_down",self, "constraint_quest_state_pressed")
