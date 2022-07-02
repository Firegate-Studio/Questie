tool
extends Control

# Called when clicking on has_item contraints
signal has_item_request()
# Called when clicking on has_quest constraint
signal has_quest_request()
# Called when clicking on quest_state constraint
signal quest_state_request()

# Called when clicling on the get_item trigger
signal get_item_request()

# Called when clicling on the collect task
signal collect_request()

var constraint_has_item : Button
var constraint_has_quest : Button
var constraint_quest_state : Button

var trigger_area_bounds : Button
var trigger_get_item : Button

var task_collect : Button
var task_fetch : Button
var task_kill : Button

# constraints-----------------------------------------------------------------

func constraint_has_item_pressed(): 
	print("[questie]: has item contraint requested")
	emit_signal("has_item_request")

func constraint_has_quest_pressed(): 
	print("[questie]: has item constraint requested")
	emit_signal("has_quest_request")

func constraint_quest_state_pressed(): 
	print("[questie]: quest state constraint requested")
	emit_signal("quest_state_request")

# Triggers-----------------------------------------------------------------------

func trigger_area_bounds_pressed(): 
	print("[questie]: area bounds trigger requested")

func trigger_get_item_pressed():
	print("[questie]: get item trigger requested")
	emit_signal("get_item_request")

# Tasks---------------------------------------------------------------------------

func task_collect_pressed():
	print("[questie]: collect task requested")
	emit_signal("collect_request")

func _enter_tree():

	# Get references from interface
	constraint_has_item = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/has item block"
	constraint_has_quest = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/has quest block"
	constraint_quest_state = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/state quest block"

	trigger_get_item = $"ScrollContainer/VBoxContainer/Triggers/GridContainer/get item block"

	task_collect = $"ScrollContainer/VBoxContainer/Tasks/GridContainer/collect block"

	# Subscribe constraints events
	constraint_has_item.connect("button_down", self, "constraint_has_item_pressed")
	constraint_has_quest.connect("button_down", self, "constraint_has_quest_pressed")
	constraint_quest_state.connect("button_down",self, "constraint_quest_state_pressed")

	# Subscribe trigger events
	trigger_get_item.connect("button_down", self, "trigger_get_item_pressed")

	# Subscribe task events
	task_collect.connect("button_down", self,  "task_collect_pressed")

func _exit_tree():

	# Unsubscribe constraints events
	constraint_has_item.disconnect("button_down", self, "constraint_has_item_pressed")
	constraint_has_quest.disconnect("button_down", self, "constraint_has_quest_pressed")
	constraint_quest_state.disconnect("button_down",self, "constraint_quest_state_pressed")

	# Unubscribe trigger events
	trigger_get_item.disconnect("button_down", self, "trigger_get_item_pressed")

	# Subscribe task events
	task_collect.disconnect("button_down", self,  "task_collect_pressed")
