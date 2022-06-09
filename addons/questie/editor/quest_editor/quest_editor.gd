# The interface responsable for building a quest from scratch or modifying it

tool
extends ColorRect

# Represent a list which contains all quests created
#
# To open a quest you should click on the quest with the 
# name of the quest you would like to modify
#
# When you change the name of your quest, the button name
# changes too  
var quest_list

# Represent the area where you can add some [elements] to the quest
#
# these elements are divided in 4 main categories:
# - **contstraints**: rules which must be satisfied to get the quest
# - **triggers**: what will activate the quest (i.e. discovery a dungeon or collect a specific item)
# - **tasks**: the objective that must be fullfilled to complete the quest and get the reward (i.e. kill, collect resource, ..., etc.)
# - **rewards**: what will you get when completing the quest
var workspace

# A list of elements which add to the workspace a specific node with exposed properties. 
# The element contains only an icon and a label with the name of the node you will add 
# clicking on it
var elements

# An interface which can call operations (i.e. add a quest)
var toolbar 

var database

# Called when the [NewQuestButton] is pressed from toolbar
func on_new_quest_button_pressed():
	database.push_new_quest()
	var uuid : String = database.data[database.data.size()-1].uuid
	var quest_label = quest_list.add_quest_button(uuid)
	quest_label.delete_btn.connect("button_down", self, "erase_quest_from_database", [uuid])
	
func erase_quest_from_database(var uuid : String): 
	print("[questie]: todo - remove quest label from database")

func _enter_tree(): 
	database = load("res://questie/quest-db.tres")
	toolbar = $"VBoxContainer/Toolbar"
	quest_list = $"VBoxContainer/HBoxContainer2/VBoxContainer/quest list/ScrollContainer/VBoxContainer"
	
	toolbar.get_node("new quest").connect("button_down", self, "on_new_quest_button_pressed")

func _exit_tree(): 
	toolbar.get_node("new quest").disconnect("button_down", self, "on_new_quest_button_pressed")
