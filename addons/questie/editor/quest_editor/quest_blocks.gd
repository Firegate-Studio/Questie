tool
extends Control

# Called when clicking on has_item contraints
signal has_item_request()
# Called when clicking on has_quest constraint
signal has_quest_request()
# Called when clicking on quest_state constraint
signal quest_state_request()
# called when clicking on is_location constraint
signal is_location_constraint_request()

# Called when clicking on the get_item trigger
signal get_item_request()
# Called when clicking on is_location trigger
signal is_location_trigger_request()
signal interact_item_trigger_requested()
signal interact_character_trigger_requested()

# Called when clicking on the collect task
signal collect_request()
signal go_to_task_request()
signal kill_task_request()
signal talk_to_request()
signal interact_item_task_requested()
signal interact_character_task_requested()

# called when clicking on the get item reward button
signal add_item_reward_request()
# called when clicking on the new quest reward button
signal new_quest_reward_request()

var constraint_has_item : Button
var constraint_has_quest : Button
var constraint_quest_state : Button
var constraint_is_location: Button

var trigger_area_bounds : Button
var trigger_get_item : Button
var trigger_is_location : Button
var trigger_interact_item : Button
var trigger_interact_character : Button

var task_collect : Button
var task_go_to : Button
var task_kill : Button
var task_talk : Button
var task_interact_item : Button
var task_interact_character : Button

var reward_get_item : Button
var reward_new_quest : Button

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
	
func constraint_is_location_pressed():
	print("[Questie]: is location constraint requested")
	emit_signal("is_location_constraint_request")

# Triggers-----------------------------------------------------------------------

func trigger_area_bounds_pressed(): 
	print("[questie]: area bounds trigger requested")

func trigger_get_item_pressed():
	print("[questie]: get item trigger requested")
	emit_signal("get_item_request")
	
func trigger_is_location_pressed():
	print("[Questie]: is location trigger requested")
	emit_signal("is_location_trigger_request")

func trigger_interact_item_pressed():
	print("[Questie]: interact with item trigger requested")
	emit_signal("interact_item_trigger_requested")

func trigger_interact_character_pressed():
	print("[Questie]: interact with character trigger requested")
	emit_signal("interact_character_trigger_requested")

# Tasks---------------------------------------------------------------------------

func task_collect_pressed():
	print("[questie]: collect task requested")
	emit_signal("collect_request")
	
func task_go_to_pressed():
	print("[Questie]: go to task requested")
	emit_signal("go_to_task_request")

func task_kill_pressed():
	print("[Questie]: kill task requested")
	emit_signal("kill_task_request")

func task_talk_pressed():
	print("[Questie]: talk to task requested")
	emit_signal("talk_to_request")

func task_interact_item_pressed():
	print("[Questie]: interact with item task requested")
	emit_signal("interact_item_task_requested")

func task_interact_character_pressed():
	print("[Questie]: interact with character requested")
	emit_signal("interact_character_task_requested")

# Rewards-------------------------------------------------------------------------

func get_item_reward_pressed():
	print("[Questie]: get item reward requested")
	emit_signal("add_item_reward_request")
	
func new_quest_reward_pressed():
	print("[Questie]: new quest reward requested")
	emit_signal("new_quest_reward_request")	

func _enter_tree():

	# Get references from interface
	constraint_has_item = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/has item block"
	constraint_has_quest = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/has quest block"
	constraint_quest_state = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/state quest block"
	constraint_is_location = $"ScrollContainer/VBoxContainer/Constraints/GridContainer/Is Location block"

	trigger_get_item = $"ScrollContainer/VBoxContainer/Triggers/GridContainer/get item block"
	trigger_is_location = $"ScrollContainer/VBoxContainer/Triggers/GridContainer/is location block"
	trigger_interact_item = $"ScrollContainer/VBoxContainer/Triggers/GridContainer/Interact Item"
	trigger_interact_character = $"ScrollContainer/VBoxContainer/Triggers/GridContainer/Interact character"

	task_collect = $"ScrollContainer/VBoxContainer/Tasks/GridContainer/collect block"
	task_go_to = $"ScrollContainer/VBoxContainer/Tasks/GridContainer/go to block"
	task_kill = $"ScrollContainer/VBoxContainer/Tasks/GridContainer/kill block"
	task_talk = $"ScrollContainer/VBoxContainer/Tasks/GridContainer/Talk to block"
	task_interact_item = $"ScrollContainer/VBoxContainer/Tasks/GridContainer/Interact Item Block"
	task_interact_character = $"ScrollContainer/VBoxContainer/Tasks/GridContainer/interact character block"

	reward_get_item = $"ScrollContainer/VBoxContainer/Rewards/GridContainer/Item Block"
	reward_new_quest = $"ScrollContainer/VBoxContainer/Rewards/GridContainer/quest block"

	# Subscribe constraints events
	constraint_has_item.connect("button_down", self, "constraint_has_item_pressed")
	constraint_has_quest.connect("button_down", self, "constraint_has_quest_pressed")
	constraint_quest_state.connect("button_down",self, "constraint_quest_state_pressed")
	constraint_is_location.connect("button_down", self, "constraint_is_location_pressed")

	# Subscribe trigger events
	trigger_get_item.connect("button_down", self, "trigger_get_item_pressed")
	trigger_is_location.connect("button_down", self, "trigger_is_location_pressed")
	trigger_interact_item.connect("button_down", self, "trigger_interact_item_pressed")
	trigger_interact_character.connect("button_down", self, "trigger_interact_character_pressed")

	# Subscribe task events
	task_collect.connect("button_down", self,  "task_collect_pressed")
	task_go_to.connect("button_down", self, "task_go_to_pressed")
	task_kill.connect("button_down", self, "task_kill_pressed")
	task_talk.connect("button_down", self, "task_talk_pressed")
	task_interact_item.connect("button_down", self, "task_interact_item_pressed")
	task_interact_character.connect("button_down", self, "task_interact_character_pressed")

	# Subscribe reward events
	reward_get_item.connect("button_down", self, "get_item_reward_pressed")
	reward_new_quest.connect("button_down", self, "new_quest_reward_pressed")

func _exit_tree():

	# Unsubscribe constraints events
	constraint_has_item.disconnect("button_down", self, "constraint_has_item_pressed")
	constraint_has_quest.disconnect("button_down", self, "constraint_has_quest_pressed")
	constraint_quest_state.disconnect("button_down",self, "constraint_quest_state_pressed")
	constraint_is_location.disconnect("button_down", self, "constraint_is_location_pressed")

	# Unsubscribe trigger events
	trigger_get_item.disconnect("button_down", self, "trigger_get_item_pressed")
	trigger_is_location.disconnect("button_down", self, "trigger_is_location_pressed")
	trigger_interact_item.disconnect("button_down", self, "trigger_interact_item_pressed")
	trigger_interact_character.disconnect("button_down", self, "trigger_interact_character_pressed")

	# Unsubscribe task events
	task_collect.disconnect("button_down", self,  "task_collect_pressed")
	task_go_to.disconnect("button_down", self, "task_go_to_pressed")
	task_kill.disconnect("button_down", self, "task_kill_pressed")
	task_talk.disconnect("button_down", self, "task_talk_pressed")
	task_interact_item.disconnect("button_down", self, "task_interact_item_pressed")
	task_interact_character.disconnect("button_down", self, "task_interact_character_pressed")

	# Subscribe reward events
	reward_get_item.disconnect("button_down", self, "get_item_reward_pressed")
	reward_new_quest.disconnect("button_down", self, "new_quest_reward_pressed")
