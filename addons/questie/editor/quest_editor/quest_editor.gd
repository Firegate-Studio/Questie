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
var blocks

# A container holding all quest information in viewport
var quest_data_container

# An interface which can call operations (i.e. add a quest, delete quest)
var toolbar 

# A section that contains a floating text
# when clicking on a quest item, this section will be replaced from the workspace
var empty_workspace

# The list containing all quest constraints
var constraints_list

# Contains all constraints [UUID] generated
var constraints_uuid_map = {}

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

	# Clear viewport
	for child in constraints_list.get_children():
		constraints_list.remove_child(child)
		child.queue_free()

	# Load quest informations
	for data in database.data:
		if not quest_tree.uuid_map.has(item.get_instance_id()) or not quest_tree.uuid_map[item.get_instance_id()]==data.uuid: continue 
		
		print("[questie]: quest uuid("+quest_tree.uuid_map[item.get_instance_id()])
		quest_data_container.quest_title.text = data.title
		quest_data_container.description.text = data.description
		
		# Load constraints
		for element in data.constraints:

			# If has_item data
			if element is Constraint_HasQuest:

				# Construct part
				var part = load("res://addons/questie/editor/quest_editor/parts/has_quest_part.tscn").instance()

				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in constraints_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					constraints_uuid_map[part.get_instance_id()] = element.uuid
					constraints_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, constraints_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					constraints_uuid_map[part.get_instance_id()] = element.uuid


				constraints_list.add_child(part)

				part.quest.text = database.get_data(element.quest).title
				part.uuid.text = element.quest
				part.refresh()

				part.connect("quest_select", self, "has_quest_changed")
				part.connect("delete", self, "delete_constraint_part")

				# Log 
				print("[questie]: loaded constraint item with [uuid]: " + element.uuid)


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

# @brief					Find an old keu in dictionary
# @param new				the new key in dictionary
# @param value				the value to compare
# @param dictionary			the dictionary to inspect
# @return					the old value in dictionary
func find_old_key_in_dictionary(var new, var value, var dictionary : Dictionary):

	var old = null

	for key in dictionary.keys():

		if not dictionary[key] == value and key == new: continue

		old = key

		break

	return old

# @brief				Remove old key from dictionary
# @param dictionary		the dictionary to remap
# @param value			the value to duplicate
func remap_uuid_map(var dictionary, var value):

	# Prepare data for remapping
	var old = null

	for key in dictionary.keys():
		
		# Ignore invalid keys
		if not dictionary[key] == value: continue

		# Register found data
		old = key

		break

	dictionary.erase(old)

	return dictionary


##################################################################################################################
# CONSTRAINTS
##################################################################################################################

func has_quest_constraint():

	# Prepare part to add 
	var part = load("res://addons/questie/editor/quest_editor/parts/has_quest_part.tscn").instance()

	# Get quest UUID
	var uuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.get_data(uuid)

	# Load quest part
	var constraint = data.push_constraint(data.ConstraintType.HAS_QUEST, data.uuid)
	constraints_list.add_child(part)

	# Register constraint uuid
	constraints_uuid_map[part.get_instance_id()] = constraint.uuid

	# Subscribe events
	part.connect("quest_select", self, "has_quest_changed")
	part.connect("delete", self, "delete_constraint_part")

# @brief				Update the has quest constraint
# @param id				the id selected from the popup menu
# @param instance_id	the instance_id of the modified part				
func has_quest_changed(var id, var instance_id): 
	
	# Get quest UUID for the current quest
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]

	# Get quest data
	var data = database.get_data(quuid)

	# Check quest data
	if not data:

		# Log error
		print("[questie]: invalid quest data!")

		return

	# get constraint UUID
	var cuuid = constraints_uuid_map[instance_id]

	# Get constraint of the displayed quest
	var constraint = data.get_constraint(cuuid)

	# Check if constraint is valid
	if not constraint:

		# Log error
		print("[questie]: can't retrieve constraint data from quest with [uuid]: " + data.uuid)
		print(instance_id)

		return

	# Update questo to the quest we want track over time
	constraint.quest = database.data[id].uuid

	# Log
	print("[questie]: set quest to " + constraint.quest + " for constraint with [uuid]: " + constraint.uuid)

# @brief				Delete a constraint part
# @param part			The part to destroy
func delete_constraint_part(var part):

	# The current quest UUID
	var quest_uuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]

	# Get quest data
	var quest_data = database.get_data(quest_uuid)

	# Check data for validation
	if not quest_data:

		# Log error
		print("[questie]: invalid quest data for quest with [uuid]: " + quest_uuid)

		return

	# Get constraint UUID
	var constraint_uuid = constraints_uuid_map[part.get_instance_id()]

	# Get constraint
	var constraint = quest_data.get_constraint(constraint_uuid)

	# Check constraint data validation
	if not constraint:

		# Log error
		print("[questie]: invalid constraint data for the constrati with [uuid]: " + constraint_uuid)

		return

	# Erase constraint UUID from map
	constraints_uuid_map.erase(part.get_instance_id())
	quest_data.erase_constraint(constraint_uuid)
	constraints_list.remove_child(part)
	part.queue_free()

###############################################################################################################

func _enter_tree():
	quest_tree = get_node("VBoxContainer/HBoxContainer2/quest tree/Tree")
	toolbar = $"VBoxContainer/Toolbar"
	empty_workspace = get_node("VBoxContainer/HBoxContainer2/empty")
	workspace = get_node("VBoxContainer/HBoxContainer2/workspace area")
	quest_data_container = workspace.get_node("HBoxContainer/ScrollContainer/data")
	blocks = workspace.get_node("HBoxContainer/Quest Blocks")
	constraints_list = workspace.get_node("HBoxContainer/ScrollContainer/data/constraints section/margin/container")
	
func _ready():
	toolbar.new_quest_btn.connect("button_down", self, "new_quest_request")
	toolbar.delete_quest_btn.connect("button_down", self, "delete_quest")
	
	quest_tree.connect("item_selected", self, "load_workspace")

	quest_data_container.quest_title.connect("text_changed", self, "update_quest_title")
	quest_data_container.description.connect("text_changed", self, "update_quest_description")
	
	# Subscribe quest blocks events
	blocks.connect("has_quest_request", self, "has_quest_constraint")


