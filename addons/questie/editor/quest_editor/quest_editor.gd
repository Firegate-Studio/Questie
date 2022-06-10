# The interface responsable for building a quest from scratch or modifying it

tool
extends Control

# Represent a list which contains all quests created
#
# To open a quest you should click on the quest with the 
# name of the quest you would like to modify
#
# When you change the name of your quest, the button name
# changes too  
var quest_tree

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

var database = preload("res://questie/quest-db.tres")

# Handle a request to create a new quest
func new_quest_request():
	
	# Check if database has been loaded
	if not database:
		print("[questie]: quest database not found!")
		return

	# Generate new quest
	database.push_new_quest()
	quest_tree.add_quest_item(database.data[database.data.size() - 1].uuid)

func _enter_tree():
	quest_tree = get_node("VBoxContainer/HBoxContainer2/quest tree/Tree")
	toolbar = $"VBoxContainer/Toolbar"

func _ready():
	toolbar.new_quest_btn.connect("button_down", self, "new_quest_request")

