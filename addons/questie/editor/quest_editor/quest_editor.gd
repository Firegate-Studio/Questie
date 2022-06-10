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

# A container holding all quest information in viewport
var quest_data_container

# An interface which can call operations (i.e. add a quest, delete quest)
var toolbar 

# A section that contains a floating text
# when clicking on a quest item, this section will be replaced from the workspace
var empty_workspace

var database = preload("res://questie/quest-db.tres")

# @brief		Handle a request to create a new quest
func new_quest_request():
	
	# Check if database has been loaded
	if not database:
		print("[questie]: quest database not found!")
		return

	# Generate new quest
	database.push_new_quest()
	var uuid
	if database.data.size() == 0:
		uuid = database.data[0].uuid
	else:
		uuid = database.data[database.data.size() - 1].uuid
	quest_tree.add_quest_item(uuid)

# @brief		show workspace and loads quest data
func load_workspace():
	var item = quest_tree.get_selected()
	
	# Check if selelected item si valid
	if not item: 
		print("[questie]: the selected item is invalid in [quest_tree.gd]")
		return

	# Load quest informations
	for data in database.data:
		if not quest_tree.uuid_map.has(item.get_instance_id()) or not quest_tree.uuid_map[item.get_instance_id()]==data.uuid: continue 
		
		print("[questie]: quest uuid("+quest_tree.uuid_map[item.get_instance_id()])
		quest_data_container.quest_title.text = data.title
		quest_data_container.description.text = data.description

		#TODO: area loading
		print("[questie]: ...nodes loading not yet ported...")


	# Swap workspace visibility
	empty_workspace.hide()
	workspace.show()

# @brief		removes a quest from viewport and database
func delete_quest():
	var item = quest_tree.get_selected()

	# Check if selected item is valid - TODO: manage extensio for folding system when implemented
	if not item:
		print("[questie]: selected item is not valid")
		return

	# Remove quest
	database.erase_quest(quest_tree.uuid_map[item.get_instance_id()])
	quest_tree.remove_quest_item(item)

	# Swap workspace visibility
	workspace.hide()
	empty_workspace.show()

# @brief				update the quest title
# @param title			the new quest title
func update_quest_title(var title : String):
	
	# Retrieve quest uuid
	var uuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]

	# Retrive quest data	
	var quest_data = database.get_data(uuid)
	if not quest_data:
		print("[questie]: quest data is invalid!")
		return

	quest_data.title = title
	quest_tree.get_selected().set_text(0, title)

# @brief				update the quest description
func update_quest_description():

	# Retrieve quest uuid
	var uuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]

	# Retrive quest data	
	var quest_data = database.get_data(uuid)
	if not quest_data:
		print("[questie]: quest data is invalid!")
		return

	quest_data.description = quest_data_container.description.text


func _enter_tree():
	quest_tree = get_node("VBoxContainer/HBoxContainer2/quest tree/Tree")
	toolbar = $"VBoxContainer/Toolbar"
	empty_workspace = get_node("VBoxContainer/HBoxContainer2/empty")
	workspace = get_node("VBoxContainer/HBoxContainer2/workspace area")
	quest_data_container = workspace.get_node("HBoxContainer/ScrollContainer/data")
	
func _ready():
	toolbar.new_quest_btn.connect("button_down", self, "new_quest_request")
	toolbar.delete_quest_btn.connect("button_down", self, "delete_quest")
	
	quest_tree.connect("item_selected", self, "load_workspace")

	quest_data_container.quest_title.connect("text_changed", self, "update_quest_title")
	quest_data_container.description.connect("text_changed", self, "update_quest_description")

