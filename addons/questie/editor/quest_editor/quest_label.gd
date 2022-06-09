# A button representing a quest 
tool
extends Control
class_name QuestLabel

# the [uuid] points to a quest in quest database
var uuid : String

# The button to open load the quest settings
var quest_btn : Button

# The butto to delete the quest
var delete_btn : Button

func _enter_tree():
	quest_btn = $"HBoxContainer/quest"
	delete_btn = $"HBoxContainer/delete"

