extends "res://addons/questie/nodes/constraints/constraint_node.gd"

# the location identifier
var location_id : String

# the category identifier
var category_id : String

func _enter_tree():
	QuestieEvents.connect("player_enter_location", self, "on_player_enter_location")
	QuestieEvents.connect("player_exit_location", self, "on_player_exit_location")
		

func _exit_tree():
	QuestieEvents.disconnect("player_enter_location", self, "on_player_enter_location")
	QuestieEvents.disconnect("player_exit_location", self, "on_player_exit_location")
		

func on_player_enter_location(location_id): 
	bypassed = true
	emit_signal("constraint_passed", id)

func on_player_exit_location(location_id): 
	bypassed = false
	emit_signal("constraint_failed", id)

   
