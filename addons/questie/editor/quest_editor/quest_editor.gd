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


var constraints_list					# The list containing all quest constraints
var triggers_list						# The list containing all quest constraints
var tasks_list							# The list containing all quest tasks
var rewards_list						# The list containing all quest rewards


var constraints_uuid_map = {}			# Contains all constraints [UUID] generated
var triggers_uuid_map = {}				# Contains all triggers [UUID] generated
var tasks_uuid_map = {}					# Contains all tasks [UUID] generated
var rewards_uuid_map = {}				# Contains all rewards [UUID] generated

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

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

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

	for child in triggers_list.get_children():
		triggers_list.remove_child(child)
		child.queue_free()

	for child in tasks_list.get_children():
		tasks_list.remove_child(child)
		child.queue_free()

	for child in rewards_list.get_children():
		rewards_list.remove_child(child)
		child.queue_free()
	
	# delete # when initializing rewars list in _enter_tree() function
	#for child in rewards_list.get_children():
	#	rewards_list.remove_child(child)
	#	child.queue_free()

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
				var part = load("res://addons/questie/editor/quest_editor/parts/constraints/has_quest_part.tscn").instance()

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
				
				var pqdata = database.get_data(element.quest)
				if pqdata:

					# Load GUI block
					part.quest.text = database.get_data(element.quest).title
					part.uuid.text = element.quest
					part.refresh()

				part.connect("quest_select", self, "has_quest_changed")
				part.connect("delete", self, "delete_constraint_part")

				# Log 
				print("[questie]: loaded constraint item with [uuid]: " + element.uuid)

			if element is Constraint_HasItem:

				# Construct part
				var part = load("res://addons/questie/editor/quest_editor/parts/constraints/has_item_part.tscn").instance()

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
				

				# Delete from here
				# Load item database
				var item_db = load("res://questie/item-db.tres")

				# Check item database validation
				if not item_db:

					# Log error
					print("[questie]: items database not found. Please reinstall Questie")

					return

				# Get item data
				var item_data = item_db.find_data(element.item, element.category)
				#if not item_data:
				#	
				#	# Log
				#	print("[questie]: item data not found")
				#	
				#	return
					
				
				if item_data:
				
					# Update interface block
					part.item.text = item_data.title
					part.category.text = part.category.get_popup().get_item_text(element.category - 1)
					part.quantity.value = element.quantity
					part.refresh(element.category)

				part.connect("item_changed", self, "has_item_changed")
				part.connect("category_changed", self, "has_item_category_changed")
				part.connect("quantity_changed", self, "has_item_quantity_changed")
				part.connect("delete_part", self, "delete_constraint_part")

				# Log 
				print("[questie]: loaded constraint item with [uuid]: " + element.uuid)

			if element is Constraint_QuestState:

				# Construct part
				var part = load("res://addons/questie/editor/quest_editor/parts/constraints/quest_state_part.tscn").instance()

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
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				# Update constraint block
				var pqdata = database.get_data(element.quest)
				if pqdata:
					part.quest.text = database.get_data(element.quest).title
					part.state.text = part.state.get_popup().get_item_text(element.state)
					part.refresh()

				# Subscribe events
				part.connect("delete", self, "delete_constraint_part")
				part.connect("quest_changed", self, "quest_state_quest_changed")
				part.connect("state_changed", self, "quest_state_state_changed")

				# Log 
				print("[questie]: loaded constraint item with [uuid]: " + element.uuid)

			if element is Constraint_IsLocation:
				var part = load("res://addons/questie/editor/quest_editor/parts/constraints/is_location_part.tscn").instance()

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
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				# update constraint block
				part.category_id = element.category_id
				part.location_id = element.location_id
				part.load_categories_from_database()
				part.load_locations_from_database(element.category_id)
				part.category_menu.text = part.category_menu.get_popup().get_item_text(element.category_index)
				part.location_menu.text = part.location_menu.get_popup().get_item_text(element.location_index)

				# subscribe events
				part.connect("category_selected", self, "is_location_constraint_category_selected", [element, quest_data])
				part.connect("location_selected", self, "is_location_constraint_location_selected", [element, quest_data])
				part.connect("deletion_request", self, "is_location_constraint_deletion_requested", [element, quest_data])

		for element in data.triggers:

			if element is Trigger_GetItem:

				# Preload scene block
				var part = load("res://addons/questie/editor/quest_editor/parts/triggers/get_item_part.tscn").instance()
				
				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in triggers_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					triggers_uuid_map[part.get_instance_id()] = element.uuid
					triggers_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, constraints_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					triggers_uuid_map[part.get_instance_id()] = element.uuid
				
				triggers_list.add_child(part)
				
				var qdata = database.get_data(element.owner)
				if qdata:
					var db = load("res://questie/item-db.tres")
					part.uuid.text = element.item_uuid
					part.item.text = db.find_data(element.item_uuid, element.item_category).title
					part.category.text = part.category.get_popup().get_item_text(element.item_category - 1)

				# Subscribe trigger events
				part.connect("item_selected", self, "trigger_get_item_selected", [part, element])
				part.connect("destruction_requested", self, "trigger_get_item_delete", [part, element])
		
			if element is Trigger_IsLocation:
				var part = load("res://addons/questie/editor/quest_editor/parts/triggers/is_location_part.tscn").instance()

				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in triggers_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					triggers_uuid_map[part.get_instance_id()] = element.uuid
					triggers_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, triggers_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					triggers_uuid_map[part.get_instance_id()] = element.uuid


				triggers_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				# update constraint block
				part.category_id = element.category_id
				part.location_id = element.location_id
				part.load_categories_from_database()
				part.load_locations_from_database(element.category_id)
				part.category_menu.text = part.category_menu.get_popup().get_item_text(element.category_index)
				part.location_menu.text = part.location_menu.get_popup().get_item_text(element.location_index)

				# subscribe events
				part.connect("category_selected", self, "is_location_trigger_category_selected", [element, quest_data])
				part.connect("location_selected", self, "is_location_trigger_location_selected", [element, quest_data])
				part.connect("deletion_request", self, "is_location_trigger_deletion_requested", [element, quest_data])

			if element is Trigger_ItemInteraction:
				var part = load("res://addons/questie/editor/quest_editor/parts/triggers/item_interaction_part.tscn").instance()

				# Check if the triggers  map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in triggers_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					triggers_uuid_map[part.get_instance_id()] = element.uuid
					triggers_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, triggers_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					triggers_uuid_map[part.get_instance_id()] = element.uuid


				triggers_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				# get item database
				var item_db = load("res://questie/item-db.tres")
				var item_index = item_db.find_data_index(element.item_id, element.category)
				var item_data = item_db.find_data(element.item_id, element.category)
				
				if item_data: 
					# update trigger interface
					part.autoload(element.category, item_data.title, item_index)

				# subscribe events
				part.connect("category_selected", self, "item_interaction_trigger_category_selected", [element, quest_data])
				part.connect("item_selected", self, "item_interaction_trigger_item_selected", [element, quest_data])
				part.connect("deletion_request", self, "item_interaction_trigger_deletion_requested", [element, quest_data, part])
				
			if element is Trigger_CharacterInteraction:
				var part = load("res://addons/questie/editor/quest_editor/parts/triggers/character_interaction_part.tscn").instance()

				# Check if the triggers  map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in triggers_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					triggers_uuid_map[part.get_instance_id()] = element.uuid
					triggers_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, triggers_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					triggers_uuid_map[part.get_instance_id()] = element.uuid


				triggers_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return
				
				# get character_data
				var character_data = load("res://questie/characters-db.tres").characters[element.character_idx]
				if not character_data:
					print("[Questie]: can not retrieve character data from characters database for character with id: " + element.character_id)
					return
				
				if element.character_idx > -1:
					# update part information
					part.autoload(character_data.title, element.character_id, element.character_idx)

				# subscribe events
				part.connect("character_selected", self, "interaction_character_trigger_character_selected", [element, quest_data])
				part.connect("deletion_request", self, "interaction_character_trigger_deletion_request", [element, quest_data, part])

			if element is Trigger_EnterLocation: 
				var part = load("res://addons/questie/editor/quest_editor/parts/triggers/enter_location_part.tscn").instance()

				# Check if the triggers  map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in triggers_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					triggers_uuid_map[part.get_instance_id()] = element.uuid
					triggers_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, triggers_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					triggers_uuid_map[part.get_instance_id()] = element.uuid


				triggers_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				part.autoload(element.location_id, element.location_index, element.category_index)

				part.connect("location_selected", self, "enter_location_trigger_location_selected", [element, quest_data])
				part.connect("category_selected", self, "enter_location_trigger_category_selected", [element, quest_data])
				part.connect("deletion_request", self, "enter_location_trigger_deletion_requested", [part, element, quest_data])

			if element is Trigger_ExitLocation:
				var part = load("res://addons/questie/editor/quest_editor/parts/triggers/exit_location_part.tscn").instance()

				# Check if the triggers  map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in triggers_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					triggers_uuid_map[part.get_instance_id()] = element.uuid
					triggers_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, triggers_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					triggers_uuid_map[part.get_instance_id()] = element.uuid


				triggers_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				part.autoload(element.location_id, element.location_index, element.category_index)

				part.connect("location_selected", self, "exit_location_trigger_location_selected", [element, quest_data])
				part.connect("category_selected", self, "exit_location_trigger_category_selected", [element, quest_data])
				part.connect("deletion_request", self, "exit_location_trigger_deletion_requested", [part, element, quest_data])


		for element in data.tasks:
			
			if element is Task_CollectItem:

				# Preload scene block
				var part = load("res://addons/questie/editor/quest_editor/parts/tasks/collect_item_part.tscn").instance()
				
				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in tasks_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					tasks_uuid_map[part.get_instance_id()] = element.uuid
					tasks_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, constraints_uuid_map))
				
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					tasks_uuid_map[part.get_instance_id()] = element.uuid
			
				tasks_list.add_child(part)
			
				var qdata = database.get_data(element.owner)
				if qdata:
					var db = load("res://questie/item-db.tres")
					var item_data = db.find_data(element.item_uuid, element.category)
					if not item_data:
						part.item.text = "item"
						part.category.text = part.category.get_popup().get_item_text(element.category)
						part.load_items_from_database(element.category)
						part.quantity.value = element.quantity
					else:	
						part.item.text = item_data.title
						part.category.text = part.category.get_popup().get_item_text(element.category - 1)
						part.load_items_from_database(element.category)
						part.quantity.value = element.quantity

				# Subscribe events
				part.connect("item_selected", self, "task_collect_item_selected",[qdata, element])
				part.connect("category_selected", self, "task_collect_category_selected", [qdata, element])
				part.connect("quantity_changed", self, "taks_collect_quantity_changed", [qdata, element])
				part.connect("delete_part_requested", self, "task_collect_delete", [qdata, element])

			if element is Task_GoTo:
				var part = load("res://addons/questie/editor/quest_editor/parts/triggers/is_location_part.tscn").instance()

				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in tasks_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					tasks_uuid_map[part.get_instance_id()] = element.uuid
					tasks_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, tasks_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					tasks_uuid_map[part.get_instance_id()] = element.uuid


				tasks_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				# update constraint block
				part.category_id = element.category_id
				part.location_id = element.location_id
				part.load_categories_from_database()
				part.load_locations_from_database(element.category_id)
				part.category_menu.text = part.category_menu.get_popup().get_item_text(element.category_index)
				part.location_menu.text = part.location_menu.get_popup().get_item_text(element.location_index)

				# subscribe events
				part.connect("category_selected", self, "go_to_task_category_selected", [element, quest_data])
				part.connect("location_selected", self, "go_to_task_location_selected", [element, quest_data])
				part.connect("deletion_request", self, "go_to_task_deletion_requested", [element, quest_data])

			if element is Task_Kill:
				var part = load("res://addons/questie/editor/quest_editor/parts/tasks/kill_part.tscn").instance()

				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in tasks_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					tasks_uuid_map[part.get_instance_id()] = element.uuid
					tasks_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, tasks_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					tasks_uuid_map[part.get_instance_id()] = element.uuid


				tasks_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				# load interface
				part.autoload(element)

				# subcribe events
				part.connect("quantity_changed", self, "kill_task_quantity_changed", [element, quest_data])
				part.connect("character_selected", self, "kill_task_character_selected", [element, quest_data])
				part.connect("deletion_request", self, "kill_task_deletion_requested", [element, quest_data, part])

			if element is Task_TalkTo:
				var part = load("res://addons/questie/editor/quest_editor/parts/tasks/talk_to_part.tscn").instance()

				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in tasks_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					tasks_uuid_map[part.get_instance_id()] = element.uuid
					tasks_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, tasks_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					tasks_uuid_map[part.get_instance_id()] = element.uuid


				tasks_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				# load interface
				part.autoload(element)

				# subcribe events
				part.connect("character_selected", self, "kill_task_character_selected", [element, quest_data])
				part.connect("deletion_request", self, "kill_task_deletion_requested", [element, quest_data, part])
			
			if element is Task_ItemInteraction:
				var part = load("res://addons/questie/editor/quest_editor/parts/tasks/item_interaction_part.tscn").instance()

				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in tasks_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					tasks_uuid_map[part.get_instance_id()] = element.uuid
					tasks_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, tasks_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					tasks_uuid_map[part.get_instance_id()] = element.uuid


				tasks_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return

				# get item database
				var item_db = load("res://questie/item-db.tres")
				var item_index = item_db.find_data_index(element.item_id, element.category)
				var item_data = item_db.find_data(element.item_id, element.category)
				
				if item_data:
					# update trigger interface
					part.autoload(element.category, item_data.title, item_index)

				# subscribe events
				part.connect("category_selected", self, "item_interaction_task_category_selected", [element, quest_data])
				part.connect("item_selected", self, "item_interaction_task_item_selected", [element, quest_data])
				part.connect("deletion_request", self, "item_interaction_task_deletion_requested", [element, quest_data, part])

			if element is Task_CharacterInteraction:
				var part = load("res://addons/questie/editor/quest_editor/parts/tasks/character_interaction_part.tscn").instance()

				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in tasks_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					tasks_uuid_map[part.get_instance_id()] = element.uuid
					tasks_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, tasks_uuid_map))
					
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					tasks_uuid_map[part.get_instance_id()] = element.uuid


				tasks_list.add_child(part)
					
				# Get quest data
				var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
				var quest_data = database.get_data(quuid)

				# Check quest data validation
				if not quest_data:

					# Log error
					print("[questie]: can't retrieve data form quest item with [uuid]: " + quuid)

					return
				
				# get character_data
				var character_data = load("res://questie/characters-db.tres").characters[element.character_idx]
				if not character_data:
					print("[Questie]: can not retrieve character data from characters database for character with id: " + element.character_id)
					return
				
				if element.character_idx > -1: 
					# update part information
					part.autoload(character_data.title, element.character_id, element.character_idx)

				# subscribe events
				part.connect("character_selected", self, "interaction_character_task_character_selected", [element, quest_data])
				part.connect("deletion_request", self, "interaction_character_task_deletion_request", [element, quest_data, part])

				

		for element in data.rewards:

			if element is Reward_AddItem:

				var part = load("res://addons/questie/editor/quest_editor/parts/rewards/item_reward_part.tscn").instance()

				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in rewards_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					rewards_uuid_map[part.get_instance_id()] = element.uuid
					rewards_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, constraints_uuid_map))
				
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					rewards_uuid_map[part.get_instance_id()] = element.uuid
			
				rewards_list.add_child(part)

				var qdata = database.get_data(element.owner)
				if qdata:
					var db = load("res://questie/item-db.tres")
					var item_data = db.find_data(element.item_id, element.item_category)
					if not item_data:
						part.item_menu.text = "item"
						part.item_category.text = part.category.get_popup().get_item_text(element.category)
						part.load_items_from_database(element.category)
						part.quantity_box.value = element.quantity
					else:	
						part.item_menu.text = item_data.title
						part.category_menu.text = part.category_menu.get_popup().get_item_text(element.item_category - 1)
						part.load_items_from_database(element.item_category)
						part.quantity_box.value = element.item_quantity

				# Subscribe events
				part.connect("item_selected", self, "handle_add_item_reward_item_selected",[qdata, element])
				part.connect("category_selected", self, "handle_add_item_reward_category_selected", [qdata, element])
				part.connect("quantity_changed", self, "handle_add_item_reward_quantity_changed", [qdata, element])
				part.connect("delete_part_requested", self, "handle_add_item_reward_deletion", [qdata, element])

			if element is Reward_NewQuest:

				var part = load("res://addons/questie/editor/quest_editor/parts/rewards/quest_reward_part.tscn").instance()

				# Check if the constraints map is has valid UUID
				# NB: the second case should be used for startup; because the maps are not stored anywhere. Only at runtime editor execution
				if element.uuid in rewards_uuid_map.values():

					# Register new instance id and remove old keys from UUID map
					rewards_uuid_map[part.get_instance_id()] = element.uuid
					rewards_uuid_map.erase(find_old_key_in_dictionary(part.get_instance_id(), element.uuid, constraints_uuid_map))
				
				else:

					# Generated instance and id
					element.uuid = UUID.generate()
					rewards_uuid_map[part.get_instance_id()] = element.uuid
			
				rewards_list.add_child(part)

				var qdata = database.get_data(element.owner)
				if qdata:
					var tracked_quest = database.get_data(element.quest_id)
					part.quest_name.text = tracked_quest.title
				
				part.connect("quest_selected", self, "handle_quest_reward_quest_selected", [qdata, element])
				part.connect("delete_button_pressed", self, "handle_quest_reward_deletion", [qdata, element])

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

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

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

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

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

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

# @brief					Find an old key in dictionary
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
	var part = load("res://addons/questie/editor/quest_editor/parts/constraints/has_quest_part.tscn").instance()

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

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

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

		return

	# Update questo to the quest we want track over time
	constraint.quest = database.data[id].uuid

	# Log
	print("[questie]: set quest to " + constraint.quest + " for constraint with [uuid]: " + constraint.uuid)

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

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

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

func has_item_constraint():

	# Prepare part to add 
	var part = load("res://addons/questie/editor/quest_editor/parts/constraints/has_item_part.tscn").instance()

	# Get quest UUID
	var uuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]

	# Get data
	var data = database.get_data(uuid)

	# Load quest part
	var constraint = data.push_constraint(data.ConstraintType.HAS_ITEM, data.uuid)
	constraints_list.add_child(part)

	# Register constraint uuid
	constraints_uuid_map[part.get_instance_id()] = constraint.uuid

	# Subscribe events
	part.connect("item_changed", self, "has_item_changed")
	part.connect("category_changed", self, "has_item_category_changed")
	part.connect("quantity_changed", self, "has_item_quantity_changed")
	part.connect("delete_part", self, "delete_constraint_part")

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

func has_item_category_changed(var part, var category):

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
	var cuuid = constraints_uuid_map[part.get_instance_id()]

	# Get constraint of the displayed quest
	var constraint = data.get_constraint(cuuid)

	# Check if constraint is valid
	if not constraint:

		# Log error
		print("[questie]: can't retrieve constraint data from quest with [uuid]: " + data.uuid)

		return

	# Update questo to the quest we want track over time
	constraint.category = category
	# Log
	print("[questie]: set item_category to " + var2str(category) + " for constraint with [uuid]: " + constraint.uuid)

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

func has_item_changed(var part, var id, var category):

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
	var cuuid = constraints_uuid_map[part.get_instance_id()]

	# Get constraint of the displayed quest
	var constraint = data.get_constraint(cuuid)

	# Check if constraint is valid
	if not constraint:

		# Log error
		print("[questie]: can't retrieve constraint data from quest with [uuid]: " + data.uuid)

		return

	# Get item database
	var item_db = load("res://questie/item-db.tres")
	
	# Check item database validation
	if not item_db:
		
		# Log error
		print("[questie]: can't load item database")
		
		return

	# Update constraint item UUID
	constraint.item = item_db.find_data_by_slot(id, category).uuid

	# Log
	print("[questie]: set item to " + var2str(constraint.item) + " for constraint with [uuid]: " + constraint.uuid)

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

# @brief					Update the item quantity
# @param quantity			The new quantity
func has_item_quantity_changed(var part, var quantity): 

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
	var cuuid = constraints_uuid_map[part.get_instance_id()]

	# Get constraint of the displayed quest
	var constraint = data.get_constraint(cuuid)

	# Check if constraint is valid
	if not constraint:

		# Log error
		print("[questie]: can't retrieve constraint data from quest with [uuid]: " + data.uuid)

		return

	# Update constraint quantity
	constraint.quantity = quantity

	# Log
	print("[questie]: set has_item_quantity to " + var2str(constraint.quantity) + " for constraint with [uuid]: " + constraint.uuid)

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)


# @brief					Generates a quest state contraint inside the quest
func quest_state_constraint(): 

	# Load constraint part to add to quest
	var part = load("res://addons/questie/editor/quest_editor/parts/constraints/quest_state_part.tscn").instance()

	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)

		return

	# Generates constraint data
	var constraint_data = quest_data.push_constraint(quest_data.ConstraintType.QUEST_STATE, quuid)

	# Check constraint validation
	if not constraint_data:

		# Log error
		print("[questie]: quest constraint generation failed for quest with [uuid]: " + quuid)

		return

	constraints_uuid_map[part.get_instance_id()] = constraint_data.uuid												# Register constraint UUID to constraint map
	print("[questie]: added constraint with [uuid]: " + constraint_data.uuid + " to quest with [uuid]: " + quuid)	# Log constraint generation success

	# Add constraint to vierport
	constraints_list.add_child(part)

	# Subscribe constrain events
	part.connect("delete", self, "delete_constraint_part")
	part.connect("quest_changed", self, "quest_state_quest_changed")
	part.connect("state_changed", self, "quest_state_state_changed")

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

func quest_state_quest_changed(var part, var quest_id):

	# Get current quest data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log error
		print("[questie]: can't retrieve quest data for quest with [uuid]: " + quuid)

		return

	# Get constraint data
	var cuuid = constraints_uuid_map[part.get_instance_id()]
	var constraint_data = quest_data.get_constraint(cuuid)

	# Check constraint data validation
	if not constraint_data:

		# Log error
		print("[questie]: can't retrieve constraint data for constraint item with [uuid]: " + cuuid + " for quest item with [uuid]: " + quuid)

		return

	# Get pointing quest data
	var pquuid = database.data[quest_id].uuid 
	var pqdata = database.get_data(pquuid)

	# Check pointing quest data validation
	if not pqdata:

		# Log error
		print("[questie]: can't retrieve data from quest " + pquuid + " from constraint " + cuuid)

		return

	# Update data
	constraint_data.quest = pquuid
	
	# Log success
	print("[questie]: Set quest_state to point quest " + constraint_data.uuid + " from constraint " + cuuid)

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)

func quest_state_state_changed(var part, var state_id): 

	# Get current quest data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data for quest: " + quuid)

		return

	# Get constraint data
	var cuuid = constraints_uuid_map[part.get_instance_id()]
	var constraint_data = quest_data.get_constraint(cuuid)

	if not constraint_data:

		# Log error
		print("[questie]: can't retrive constraint " + cuuid + " from quest " + quuid)

		return

	# Update data
	constraint_data.state = state_id

	# Log success
	print("[questie]: set quest_state.state to " + var2str(constraint_data.state) + " for constraint " + constraint_data.uuid + " in quest " + quuid)

	# Save database
	ResourceSaver.save("res://questie/quest-db.tres", database)


func create_is_location_constraint():

	# load constraint part
	var part = load("res://addons/questie/editor/quest_editor/parts/constraints/is_location_part.tscn").instance()
	if not part:
		print("[Questie]: can not constraint part in quest editor")
		return
	
	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)

		return

	# Generates constraint data
	var constraint_data = quest_data.push_constraint(quest_data.ConstraintType.IS_LOCATION, quuid) 
	if not constraint_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return

	# Update UUID map
	constraints_uuid_map[part.get_instance_id()] = constraint_data.uuid
	print("[questie]: added constraint with [uuid]: " + constraint_data.uuid + " to quest with [uuid]: " + quuid)
	
	# add constraint to the quest editor viewport
	constraints_list.add_child(part)

	# subscribe events
	part.connect("category_selected", self, "is_location_constraint_category_selected", [constraint_data, quest_data])
	part.connect("location_selected", self, "is_location_constraint_location_selected", [constraint_data, quest_data])
	part.connect("deletion_request", self, "is_location_constraint_deletion_requested", [constraint_data, quest_data])

	# update database
	ResourceSaver.save("res://questie/quest-db.tres", database)

func is_location_constraint_category_selected(category_id, category_index, constraint_data, quest_data):

	constraint_data.category_id = category_id
	constraint_data.category_index = category_index
	ResourceSaver.save("res://questie/quest-db.tres", database)

func is_location_constraint_location_selected(location_id, location_index, constraint_data, quest_data):

	constraint_data.location_id = location_id
	constraint_data.location_index = location_index
	ResourceSaver.save("res://questie/quest-db.tres", database)

func is_location_constraint_deletion_requested(node, constraint_data, quest_data):
	
	constraints_list.remove_child(node)

	node.disconnect("category_selected", self, "is_location_constraint_category_selected")
	node.disconnect("location_selected", self, "is_location_constraint_location_selected")
	node.disconnect("deletion_request", self, "is_location_constraint_deletion_requested")

	constraints_uuid_map.erase(node.get_instance_id())
	quest_data.erase_constraint(constraint_data.uuid)

	node.queue_free()

	ResourceSaver.save("res://questie/quest-db.tres", database)

##################################################################################################################
# TRIGGERS
##################################################################################################################

func get_item_trigger(): 

	# Load trigger part
	var trigger = load("res://addons/questie/editor/quest_editor/parts/triggers/get_item_part.tscn").instance()
	if not trigger:
		# Log error
		print("[questie]: can't load trigger part in quest editor")
		return

	# Get quest informations
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()] 			# Opened quest in editor UUID
	var qdata = database.get_data(quuid)													# quest data stored inside the database
	if not qdata:
		# Log error
		print("[questie]: can't retrieve quest data from database for quest with [uuid]: " + quuid)
		return
	
	# Generates trigger data
	var trigger_data = qdata.push_trigger(qdata.TriggerType.GET_ITEM, quuid) 
	if not trigger_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return

	# Update UUID map
	triggers_uuid_map[trigger.get_instance_id()] = trigger_data.uuid
	print("[questie]: added trigger with [uuid]: " + trigger_data.uuid + " to quest with [uuid]: " + quuid)
	
	# Add trigger to scene
	triggers_list.add_child(trigger)

	# Subscribe trigger events
	trigger.connect("item_selected", self, "trigger_get_item_selected", [trigger, trigger_data])
	trigger.connect("destruction_requested", self, "trigger_get_item_delete", [trigger, trigger_data])	

	# Update database
	ResourceSaver.save("res://questie/quest-db.tres", database)

func trigger_get_item_selected(var item_uuid, var category, var data, var part, var trigger):

	trigger.item_uuid = item_uuid						# update trigger item UUID
	trigger.item_category = category					# update item category

	# update data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func trigger_get_item_delete(var control, var data):

	var qdata = database.get_data(data.owner)
	if not qdata:
		# Log error
		print("[questie]: can't retrieve data from database fro quest: " + data.trigger_owner)
		return

	# Erase trigger
	triggers_list.remove_child(control)
	control.disconnect("item_selected", self, "trigger_get_item_selected")					# Disable item selected event
	control.disconnect("destruction_requested", self, "trigger_get_item_delete")			# Disable destruction request event
	triggers_uuid_map.erase(control.get_instance_id())
	qdata.erase_trigger(data.uuid)
	control.queue_free()

	# update database
	ResourceSaver.save("res://questie/quest-db.tres", database)


func create_enter_location_trigger():
	var part = load("res://addons/questie/editor/quest_editor/parts/triggers/enter_location_part.tscn").instance()
	if not part:
		print("Questie: can not load enter_location part in quest editor")
		return

	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)

		return

	# Generates constraint data
	var trigger_data = quest_data.push_trigger(quest_data.TriggerType.ENTER_LOCATION, quuid) 
	if not trigger_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return

	# Update UUID map
	triggers_uuid_map[part.get_instance_id()] = trigger_data.uuid
	print("[questie]: added trigger with [uuid]: " + trigger_data.uuid + " to quest with [uuid]: " + quuid)
	
	# add constraint to the quest editor viewport
	triggers_list.add_child(part)

	# subscribe events
	part.connect("location_selected", self, "enter_location_trigger_location_selected", [trigger_data, quest_data])
	part.connect("category_selected", self, "enter_location_trigger_category_selected", [trigger_data, quest_data])
	part.connect("deletion_request", self, "enter_location_trigger_deletion_requested", [part, trigger_data, quest_data])

	ResourceSaver.save("res://questie/quest-db.tres", database)

func enter_location_trigger_location_selected(location_id, location_index, trigger_data, quest_data):
	trigger_data.location_id = location_id
	trigger_data.location_index = location_index
	ResourceSaver.save("res://questie/quest-db.tres", database)	

func enter_location_trigger_category_selected(category_index, trigger_data, quest_data):
	trigger_data.category_index = category_index
	ResourceSaver.save("res://questie/quest-db.tres", database)

func enter_location_trigger_deletion_requested(node, part, trigger_data, quest_data):
	part.disconnect("location_selected", self, "enter_location_trigger_location_selected")
	part.disconnect("category_selected", self, "enter_location_trigger_category_selected")
	part.disconnect("deletion_request", self, "enter_location_trigger_deletion_requested")

	triggers_uuid_map.erase(node.get_instance_id())
	quest_data.erase_trigger(trigger_data.uuid)

	triggers_list.remove_child(part)
	part.queue_free()
	
	ResourceSaver.save("res://questie/quest-db.tres", database)


func create_exit_location_trigger():
	var part = load("res://addons/questie/editor/quest_editor/parts/triggers/exit_location_part.tscn").instance()
	if not part:
		print("Questie: can not load enter_location part in quest editor")
		return

	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)

		return

	# Generates constraint data
	var trigger_data = quest_data.push_trigger(quest_data.TriggerType.EXIT_LOCATION, quuid) 
	if not trigger_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return

	# Update UUID map
	triggers_uuid_map[part.get_instance_id()] = trigger_data.uuid
	print("[questie]: added trigger with [uuid]: " + trigger_data.uuid + " to quest with [uuid]: " + quuid)
	
	# add constraint to the quest editor viewport
	triggers_list.add_child(part)

	# subscribe events
	part.connect("location_selected", self, "exit_location_trigger_location_selected", [trigger_data, quest_data])
	part.connect("category_selected", self, "exit_location_trigger_category_selected", [trigger_data, quest_data])
	part.connect("deletion_request", self, "exit_location_trigger_deletion_requested", [part, trigger_data, quest_data])

	ResourceSaver.save("res://questie/quest-db.tres", database)

func exit_location_trigger_location_selected(location_id, location_index, trigger_data, quest_data):
	trigger_data.location_id = location_id
	trigger_data.location_index = location_index
	ResourceSaver.save("res://questie/quest-db.tres", database)

func exit_location_trigger_category_selected(category_index, trigger_data, quest_data):
	trigger_data.category_index = category_index
	ResourceSaver.save("res://questie/quest-db.tres", database)

func exit_location_trigger_deletion_requested(node, part, trigger_data, quest_data):
	part.disconnect("location_selected", self, "exit_location_trigger_location_selected")
	part.disconnect("category_selected", self, "exit_location_trigger_category_selected")
	part.disconnect("deletion_request", self, "exit_location_trigger_deletion_requested")

	triggers_uuid_map.erase(node.get_instance_id())
	quest_data.erase_trigger(trigger_data.uuid)

	triggers_list.remove_child(part)
	part.queue_free()
	
	ResourceSaver.save("res://questie/quest-db.tres", database)


func create_interact_item_trigger():
	# load constraint part
	var part = load("res://addons/questie/editor/quest_editor/parts/triggers/item_interaction_part.tscn").instance()
	if not part:
		print("[Questie]: can not constraint part in quest editor")
		return
	
	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)

		return

	# Generates constraint data
	var trigger_data = quest_data.push_trigger(quest_data.TriggerType.INTERACT_ITEM, quuid) 
	if not trigger_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return

	# Update UUID map
	triggers_uuid_map[part.get_instance_id()] = trigger_data.uuid
	print("[questie]: added trigger with [uuid]: " + trigger_data.uuid + " to quest with [uuid]: " + quuid)
	
	# add constraint to the quest editor viewport
	triggers_list.add_child(part)

	# subscribe events
	part.connect("category_selected", self, "item_interaction_trigger_category_selected", [trigger_data, quest_data])
	part.connect("item_selected", self, "item_interaction_trigger_item_selected", [trigger_data, quest_data])
	part.connect("deletion_request", self, "item_interaction_trigger_deletion_requested", [trigger_data, quest_data, part])

	# save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func item_interaction_trigger_category_selected(category_idx, trigger_data, quest_data):
	trigger_data.category = category_idx
	ResourceSaver.save("res://questie/quest-db.tres", database)

func item_interaction_trigger_item_selected(item_idx, category_idx, trigger_data, quest_data):
	var item_db = load("res://questie/item-db.tres")

	var item_data
	match category_idx:
		ItemDatabase.ItemCategory.WEAPON:
			item_data = item_db.weapons[item_idx]
		ItemDatabase.ItemCategory.ARMOR:
			item_data = item_db.armors[item_idx]
		ItemDatabase.ItemCategory.CONSUMABLE:
			item_data = item_db.consumables[item_idx]
		ItemDatabase.ItemCategory.MATERIAL:
			item_data = item_db.materials[item_idx]
		ItemDatabase.ItemCategory.SPECIAL:
			item_data = item_db.specials[item_idx]

	trigger_data.item_id = item_data.uuid
	ResourceSaver.save("res://questie/quest-db.tres", database)

func item_interaction_trigger_deletion_requested(trigger_data, quest_data, node):
	quest_data.erase_trigger(trigger_data.uuid)
	ResourceSaver.save("res://questie/quest-db.tres", database)

	# clear viewport
	node.queue_free()


func create_interaction_character_trigger():
	# load constraint part
	var part = load("res://addons/questie/editor/quest_editor/parts/triggers/character_interaction_part.tscn").instance()
	if not part:
		print("[Questie]: can not constraint part in quest editor")
		return
	
	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)

		return

	# Generates constraint data
	var trigger_data = quest_data.push_trigger(quest_data.TriggerType.INTERACT_CHARACTER, quuid) 
	if not trigger_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return

	# Update UUID map
	triggers_uuid_map[part.get_instance_id()] = trigger_data.uuid
	print("[questie]: added trigger with [uuid]: " + trigger_data.uuid + " to quest with [uuid]: " + quuid)
	
	# add constraint to the quest editor viewport
	triggers_list.add_child(part)

	# subscribe events
	part.connect("character_selected", self, "interaction_character_trigger_character_selected", [trigger_data, quest_data])
	part.connect("deletion_request", self, "interaction_character_trigger_deletion_request", [trigger_data, quest_data, part])

func  interaction_character_trigger_character_selected(character_id, character_idx, trigger_data, quest_data):
	trigger_data.character_id = character_id
	trigger_data.character_idx = character_idx
	ResourceSaver.save("res://questie/quest-db.tres", database)

func interaction_character_trigger_deletion_request(trigger_data, quest_data, node):
	quest_data.erase_trigger(trigger_data.uuid)
	ResourceSaver.save("res://questie/quest-db.tres", database)

	# cleanup viewport
	node.queue_free()


##################################################################################################################
# TASKS
##################################################################################################################

func collect_item_task():
	var part = load("res://addons/questie/editor/quest_editor/parts/tasks/collect_item_part.tscn").instance()
	if not part:
		# Log error
		print("[questie]: can't load collect_item_part from file system")
		return

	# Retrieve quest data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
	var qdata = database.get_data(quuid)
	if not qdata:
		# Log error
		print("[questie]: can't retrieve quest data for quest with [uuid]: " + quuid)
		return
	
	var tdata = qdata.push_task(qdata.TaskType.COLLECT_ITEM, quuid)
	if not tdata:
		print("[questie]: can't generate task data for quest with [uuid]: " + quuid)
		return
	
	# Update UUID map
	tasks_uuid_map[part.get_instance_id()] = tdata.uuid
	print("[questie]: added trigger with [uuid]: " + tdata.uuid + " to quest with [uuid]: " + quuid)

	tasks_list.add_child(part)					# Add part to scene

	# Subscribe events
	part.connect("item_selected", self, "task_collect_item_selected",[qdata, tdata])
	part.connect("category_selected", self, "task_collect_category_selected", [qdata, tdata])
	part.connect("quantity_changed", self, "taks_collect_quantity_changed", [qdata, tdata])
	part.connect("delete_part_requested", self, "task_collect_delete", [qdata, tdata])

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func task_collect_item_selected(var item_uuid : String, var part, var quest_data, var task_data):
	
	task_data.item_uuid = item_uuid
	print("[questie]: set task: Collect item/Item UUID: " + item_uuid)

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func task_collect_category_selected(var category, var part, var quest_data, var task_data):

	var item_db = load("res://questie/item-db.tres")

	task_data.category = category
	print("[questie]: set task: Collect item/Category: " + var2str(category))

	var new_item = item_db.find_data_by_slot(0, category)
	if not new_item:
		return

	task_data.item_uuid = new_item.uuid
	print("[questie]: set task: Collect item/Item UUID: " + new_item.uuid)

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func taks_collect_quantity_changed(var new_amount, var part, var quest_data, var task_data):

	task_data.quantity = new_amount
	print("[questie]: set task: Collec item/Quantity: " + var2str(new_amount))

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func task_collect_delete(var part, var quest_data, var task_data):

	quest_data.erase_task(task_data.uuid)				# purge data stored

	# Unsubscibe events
	part.disconnect("item_selected", self, "task_collect_item_selected")
	part.disconnect("category_selected", self, "task_collect_category_selected")
	part.disconnect("quantity_changed", self, "taks_collect_quantity_changed")
	part.disconnect("delete_part_requested", self, "task_collect_delete")

	# Free memory
	tasks_uuid_map.erase(part.get_instance_id())		# erase task uuid from map
	tasks_list.remove_child(part)						# remove part from scene
	part.queue_free()									# release memory
	print("[questie]: task action: delete on task/Collect item")

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)


func create_go_to_task():
	# load constraint part
	var part = load("res://addons/questie/editor/quest_editor/parts/tasks/go_to_part.tscn").instance()
	if not part:
		print("[Questie]: can not constraint part in quest editor")
		return
	
	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)

		return

	# Generates constraint data
	var task_data = quest_data.push_task(quest_data.TaskType.GO_TO, quuid) 
	if not task_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return

	# Update UUID map
	tasks_uuid_map[part.get_instance_id()] = task_data.uuid
	print("[questie]: added task with [uuid]: " + task_data.uuid + " to quest with [uuid]: " + quuid)
	
	# add constraint to the quest editor viewport
	tasks_list.add_child(part)

	# subscribe events
	part.connect("category_selected", self, "go_to_task_category_selected", [task_data, quest_data])
	part.connect("location_selected", self, "go_to_task_location_selected", [task_data, quest_data])
	part.connect("deletion_request", self, "go_to_task_deletion_requested", [task_data, quest_data])

	# update database
	ResourceSaver.save("res://questie/quest-db.tres", database)

func go_to_task_category_selected(category_id, category_index, task_data, quest_data): 
	task_data.category_id = category_id
	task_data.category_index = category_index
	ResourceSaver.save("res://questie/quest-db.tres", database)

func go_to_task_location_selected(location_id, location_index, task_data, quest_data): 
	task_data.location_id = location_id
	task_data.location_index = location_index
	ResourceSaver.save("res://questie/quest-db.tres", database)

func go_to_task_deletion_requested(node, task_data, quest_data): 
	tasks_list.remove_child(node)

	node.disconnect("category_selected", self, "go_to_task_category_selected")
	node.disconnect("location_selected", self, "go_to_task_location_selected")
	node.disconnect("deletion_request", self, "go_to_task_deletion_requested")

	tasks_uuid_map.erase(node.get_instance_id())
	quest_data.erase_task(task_data.uuid)

	node.queue_free()

	ResourceSaver.save("res://questie/quest-db.tres", database)


func create_kill_task():
	# load constraint part
	var part = load("res://addons/questie/editor/quest_editor/parts/tasks/kill_part.tscn").instance()
	if not part:
		print("[Questie]: can not constraint part in quest editor")
		return
	
	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)

		return

	# Generates constraint data
	var task_data = quest_data.push_task(quest_data.TaskType.KILL, quuid) 
	if not task_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return

	# Update UUID map
	tasks_uuid_map[part.get_instance_id()] = task_data.uuid
	print("[questie]: added task with [uuid]: " + task_data.uuid + " to quest with [uuid]: " + quuid)
	
	# add constraint to the quest editor viewport
	tasks_list.add_child(part)

	# subcribe events
	part.connect("quantity_changed", self, "kill_task_quantity_changed", [task_data, quest_data])
	part.connect("character_selected", self, "kill_task_character_selected", [task_data, quest_data])
	part.connect("deletion_request", self, "kill_task_deletion_requested", [task_data, quest_data, part])

	# save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func kill_task_quantity_changed(quantity, task_data, quest_data):
	task_data.target_kills = quantity
	ResourceSaver.save("res://questie/quest-db.tres", database)

func kill_task_character_selected(character_id, character_index, task_data, quest_data):
	task_data.character_id = character_id
	task_data.character_index = character_index
	ResourceSaver.save("res://questie/quest-db.tres", database)

func kill_task_deletion_requested(task_data, quest_data, part):

	# remove task
	quest_data.erase_task(task_data.uuid)
	ResourceSaver.save("res://questie/quest-db.tres", database)

	# clear viewport
	part.queue_free()


func create_talk_to_task():
	# load constraint part
	var part = load("res://addons/questie/editor/quest_editor/parts/tasks/talk_to_part.tscn").instance()
	if not part:
		print("[Questie]: can not constraint part in quest editor")
		return
	
	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)

	# Check quest data validation
	if not quest_data:

		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)

		return

	# Generates constraint data
	var task_data = quest_data.push_task(quest_data.TaskType.TALK, quuid) 
	if not task_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return

	# Update UUID map
	tasks_uuid_map[part.get_instance_id()] = task_data.uuid
	print("[questie]: added task with [uuid]: " + task_data.uuid + " to quest with [uuid]: " + quuid)
	
	# add constraint to the quest editor viewport
	tasks_list.add_child(part)

	# subcribe events
	part.connect("character_selected", self, "talk_to_task_character_selected", [task_data, quest_data])
	part.connect("deletion_request", self, "talk_to_task_deletion_requested", [task_data, quest_data, part])

	# save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func talk_to_task_character_selected(character_id, character_index, task_data, quest_data):
	task_data.character_id = character_id
	task_data.character_index = character_index
	ResourceSaver.save("res://questie/quest-db.tres", database)

func talk_to_task_deletion_requested(task_data, quest_data, node):
	quest_data.erase_task(task_data.uuid)
	ResourceSaver.save("res://questie/quest-db.tres", database)


func create_interact_item_task():
	# load constraint part
	var part = load("res://addons/questie/editor/quest_editor/parts/tasks/item_interaction_part.tscn").instance()
	if not part:
		print("[Questie]: can not constraint part in quest editor")
		return
		
	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)
	
	# Check quest data validation
	if not quest_data:
	
		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)
	
		return
	
	# Generates constraint data
	var task_data = quest_data.push_task(quest_data.TaskType.INTERACT_ITEM, quuid) 
	if not task_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return
	
	# Update UUID map
	tasks_uuid_map[part.get_instance_id()] = task_data.uuid
	print("[questie]: added trigger with [uuid]: " + task_data.uuid + " to quest with [uuid]: " + quuid)
		
	# add constraint to the quest editor viewport
	tasks_list.add_child(part)
	
	# subscribe events
	part.connect("category_selected", self, "item_interaction_task_category_selected", [task_data, quest_data])
	part.connect("item_selected", self, "item_interaction_task_item_selected", [task_data, quest_data])
	part.connect("deletion_request", self, "item_interaction_task_deletion_requested", [task_data, quest_data, part])

	# save data
	ResourceSaver.save("res://questie/quest-db.tres", database)
	
func item_interaction_task_category_selected(category_idx, task_data, quest_data):
	task_data.category = category_idx
	ResourceSaver.save("res://questie/quest-db.tres", database)
	
func item_interaction_task_item_selected(item_idx, category_idx, task_data, quest_data):
	var item_db = load("res://questie/item-db.tres")
	
	var item_data
	match category_idx:
		ItemDatabase.ItemCategory.WEAPON:
			item_data = item_db.weapons[item_idx]
		ItemDatabase.ItemCategory.ARMOR:
			item_data = item_db.armors[item_idx]
		ItemDatabase.ItemCategory.CONSUMABLE:
			item_data = item_db.consumables[item_idx]
		ItemDatabase.ItemCategory.MATERIAL:
			item_data = item_db.materials[item_idx]
		ItemDatabase.ItemCategory.SPECIAL:
			item_data = item_db.specials[item_idx]
	
	task_data.item_id = item_data.uuid
	ResourceSaver.save("res://questie/quest-db.tres", database)
	
func item_interaction_task_deletion_requested(task_data, quest_data, node):
	quest_data.erase_task(task_data.uuid)
	ResourceSaver.save("res://questie/quest-db.tres", database)
	
	# clear viewport
	node.queue_free()


func create_interaction_character_task():
	# load constraint part
	var part = load("res://addons/questie/editor/quest_editor/parts/tasks/character_interaction_part.tscn").instance()
	if not part:
		print("[Questie]: can not constraint part in quest editor")
		return
		
	# Get current quest(the quest displayed in quest editor) data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]			# Get the current quest UUID
	var quest_data = database.get_data(quuid)
	
	# Check quest data validation
	if not quest_data:
	
		# Log Error
		print("[questie]: can't retrieve quest data from quest item with [uuid]: " + quuid)
	
		return
	
	# Generates constraint data
	var task_data = quest_data.push_task(quest_data.TaskType.INTERACT_CHARACTER, quuid) 
	if not task_data:
		# Log error
		print("[questie]: quest contraint generation failed for quest with [uuid]: " + quuid)
		return
	
	# Update UUID map
	tasks_uuid_map[part.get_instance_id()] = task_data.uuid
	print("[questie]: added trigger with [uuid]: " + task_data.uuid + " to quest with [uuid]: " + quuid)
		
	# add constraint to the quest editor viewport
	tasks_list.add_child(part)
	
	# subscribe events
	part.connect("character_selected", self, "interaction_character_task_character_selected", [task_data, quest_data])
	part.connect("deletion_request", self, "interaction_character_task_deletion_request", [task_data, quest_data, part])

	# save data
	ResourceSaver.save("res://questie/quest-db.tres", database)
	
func  interaction_character_task_character_selected(character_id, character_idx, task_data, quest_data):
	task_data.character_id = character_id
	task_data.character_idx = character_idx
	ResourceSaver.save("res://questie/quest-db.tres", database)
	
func interaction_character_task_deletion_request(task_data, quest_data, node):
	quest_data.erase_task(task_data.uuid)
	ResourceSaver.save("res://questie/quest-db.tres", database)
	
	# cleanup viewport
	node.queue_free()
	

###############################################################################################################
# REWARDS 
###############################################################################################################

func create_add_item_reward():

	var part = load("res://addons/questie/editor/quest_editor/parts/rewards/item_reward_part.tscn").instance()
	if not part:
		# log error
		print("[Questie]: can't load item_reward_part from file system")
		return

	# retrieve quest data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
	var qdata = database.get_data(quuid)
	if not qdata:
		# Log error
		print("[questie]: can't retrieve quest data for quest with [uuid]: " + quuid)
		return

	var rdata = qdata.push_reward(qdata.RewardType.ADD_ITEM, quuid)
	if not rdata:
		print("[questie]: can't generate task data for quest with [uuid]: " + quuid)
		return
	
	# Update UUID map
	rewards_uuid_map[part.get_instance_id()] = rdata.uuid
	print("[questie]: added reward with [uuid]: " + rdata.uuid + " to quest with [uuid]: " + quuid)

	rewards_list.add_child(part)					# add the part to the scene

	# subscribe events
	part.connect("item_selected", self, "handle_add_item_reward_item_selected", [qdata, rdata])
	part.connect("category_selected", self, "handle_add_item_reward_category_selected", [qdata, rdata])
	part.connect("quantity_changed", self, "handle_add_item_reward_quantity_changed", [qdata, rdata])
	part.connect("delete_part_requested", self, "handle_add_item_reward_deletion", [qdata, rdata])

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)
	
func handle_add_item_reward_item_selected(item_id : String, part, quest_data, reward_data)->void:
	reward_data.item_id = item_id
	print("[questie]: set task: Collect item/Item UUID: " + item_id)

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func handle_add_item_reward_category_selected(category,  part, quest_data, reward_data):
	var item_db = load("res://questie/item-db.tres")

	reward_data.item_category = category
	print("[questie]: set task: Collect item/Category: " + var2str(category))

	var new_item = item_db.find_data_by_slot(0, category)
	if not new_item:
		return

	reward_data.item_id = new_item.uuid
	print("[questie]: set task: Collect item/Item UUID: " + new_item.uuid)

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func handle_add_item_reward_quantity_changed(new_amount, part, quest_data, reward_data):
	reward_data.item_quantity = new_amount
	print("[questie]: set task: Collec item/Quantity: " + var2str(new_amount))

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func handle_add_item_reward_deletion(part, quest_data, reward_data):
	quest_data.erase_reward(reward_data.uuid)				# purge data stored

	# Unsubscibe events
	part.disconnect("item_selected", self, "handle_add_item_reward_item_selected")
	part.disconnect("category_selected", self, "handle_add_item_reward_category_selected")
	part.disconnect("quantity_changed", self, "handle_add_item_reward_quantity_changed")
	part.disconnect("delete_part_requested", self, "handle_add_item_reward_deletion")

	# Free memory
	rewards_uuid_map.erase(part.get_instance_id())		# erase task uuid from map
	rewards_list.remove_child(part)						# remove part from scene
	part.queue_free()									# release memory
	print("[questie]: reward action: delete on Reward/Add item")

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)


func create_quest_reward():
	var part = load("res://addons/questie/editor/quest_editor/parts/rewards/quest_reward_part.tscn").instance()
	if not part:
		# log error
		print("[Questie]: can't load item_reward_part from file system")
		return
	
	# retrieve quest data
	var quuid = quest_tree.uuid_map[quest_tree.get_selected().get_instance_id()]
	var qdata = database.get_data(quuid)
	if not qdata:
		# Log error
		print("[questie]: can't retrieve quest data for quest with [uuid]: " + quuid)
		return

	var rdata = qdata.push_reward(qdata.RewardType.NEW_QUEST, quuid)
	if not rdata:
		print("[questie]: can't generate task data for quest with [uuid]: " + quuid)
		return
	
	# Update UUID map
	rewards_uuid_map[part.get_instance_id()] = rdata.uuid
	print("[questie]: added reward with [uuid]: " + rdata.uuid + " to quest with [uuid]: " + quuid)

	rewards_list.add_child(part)					# add the part to the scene

	#subscribe events
	part.connect("quest_selected", self, "handle_quest_reward_quest_selected", [qdata, rdata])
	part.connect("delete_button_pressed", self, "handle_quest_reward_deletion", [qdata, rdata])

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func handle_quest_reward_quest_selected(quest_id, part, quest_data, reward_data): 
	reward_data.quest_id = quest_id

	#Log
	print("[Questie]: set quest to activate to [" + quest_id + "]")

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func handle_quest_reward_deletion(part, quest_data, reward_data): 
	quest_data.erase_reward(reward_data.uuid)				# purge data stored

	# Unsubscibe events
	part.disconnect("quest_selected", self, "handle_quest_reward_quest_selected")
	part.disconnect("delete_button_pressed", self, "handle_quest_reward_deletion")

	# Free memory
	rewards_uuid_map.erase(part.get_instance_id())		# erase task uuid from map
	rewards_list.remove_child(part)						# remove part from scene
	part.queue_free()									# release memory
	print("[questie]: reward action: delete on Reward/new quest")

	# Save data
	ResourceSaver.save("res://questie/quest-db.tres", database)

func _enter_tree():
	quest_tree = get_node("VBoxContainer/HBoxContainer2/quest tree/Tree")
	toolbar = $"VBoxContainer/Toolbar"
	empty_workspace = get_node("VBoxContainer/HBoxContainer2/empty")
	workspace = get_node("VBoxContainer/HBoxContainer2/workspace area")
	quest_data_container = workspace.get_node("HBoxContainer/ScrollContainer/data")
	blocks = workspace.get_node("HBoxContainer/Quest Blocks")
	constraints_list = workspace.get_node("HBoxContainer/ScrollContainer/data/constraints section/margin/ScrollContainer/container")
	triggers_list = workspace.get_node("HBoxContainer/ScrollContainer/data/triggers section/margin/ScrollContainer/container")
	tasks_list = workspace.get_node("HBoxContainer/ScrollContainer/data/tasks section/margin/ScrollContainer/container")
	rewards_list = workspace.get_node("HBoxContainer/ScrollContainer/data/rewards section/margin/ScrollContainer/container")
	
func _ready():
	toolbar.new_quest_btn.connect("button_down", self, "new_quest_request")
	toolbar.delete_quest_btn.connect("button_down", self, "delete_quest")
	
	quest_tree.connect("item_selected", self, "load_workspace")

	quest_data_container.quest_title.connect("text_changed", self, "update_quest_title")
	quest_data_container.description.connect("text_changed", self, "update_quest_description")
	
	# Subscribe quest blocks events
	blocks.connect("has_quest_request", self, "has_quest_constraint")
	blocks.connect("has_item_request", self,  "has_item_constraint")
	blocks.connect("quest_state_request", self, "quest_state_constraint")
	blocks.connect("is_location_constraint_request", self, "create_is_location_constraint")

	blocks.connect("get_item_request", self, "get_item_trigger")
	blocks.connect("interact_item_trigger_requested", self,  "create_interact_item_trigger")
	blocks.connect("interact_character_trigger_requested", self, "create_interaction_character_trigger")
	blocks.connect("enter_location_trigger_request", self, "create_enter_location_trigger")
	blocks.connect("exit_location_trigger_request", self, "create_exit_location_trigger")

	blocks.connect("collect_request", self, "collect_item_task")
	blocks.connect("go_to_task_request", self, "create_go_to_task")
	blocks.connect("kill_task_request", self, "create_kill_task")
	blocks.connect("talk_to_request", self, "create_talk_to_task")
	blocks.connect("interact_item_task_requested", self, "create_interact_item_task")
	blocks.connect("interact_character_task_requested", self, "create_interaction_character_task")

	blocks.connect("add_item_reward_request", self, "create_add_item_reward")
	blocks.connect("new_quest_reward_request", self, "create_quest_reward")
