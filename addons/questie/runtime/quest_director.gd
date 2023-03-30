# The [QuestDirector] is a component that manages the database quests
class_name QuestDirector, "res://addons/questie/editor/icons/director.png"
extends Node

# A reference to the quest database
var quest_database : QuestDatabase = preload("res://questie/quest-db.tres")
var item_db = preload("res://questie/item-db.tres")
var settings = preload("res://questie/settings.tres")


# INVENTORY SYSTEM -------------------------------------------------------------
var player_inventory = null
var inventory_system : InventorySystem = null

func setup_inventory():

	# setup inventory system
	inventory_system = InventorySystem.new()
	add_child(inventory_system)

	# Spawn inventory
	if settings.items_settings.inventory == "":
		print("[questie]: plauyer inventory is not set - reload your inventory using the settings editor")
		return
	
	player_inventory = load(settings.items_settings.inventory).instance()
	add_child(player_inventory)

	for quest in quest_database.data:
		
		for constraint in quest.constraints:

			if constraint is Constraint_HasItem:
				
				# Setup has item constraint node
				var node = load("res://addons/questie/nodes/constraint_has_item_node.tscn").instance()
				player_inventory.add_child(node)
				node.questie = self
				node.inventory = player_inventory
				node.quest_uuid = quest.uuid
				node.item_uuid = constraint.item
				node.item_category = constraint.category
				node.item_quantity = constraint.quantity
				node.uuid = constraint.uuid

			if constraint is Constraint_QuestState:
				# TODO: quest_state node
				pass	

			if constraint is Constraint_HasQuest:
				# TODO: has_quest node
				pass

		for trigger in quest.triggers:

			if trigger is Trigger_GetItem:
				
				# Setup get item node
				var node = load("res://addons/questie/nodes/get_item.tscn").instance()
				player_inventory.add_child(node)
				node.questie = self
				node.inventory = player_inventory
				node.target_uuid = trigger.item_uuid 
				node.quest_uuid = quest.uuid
				node.uuid = trigger.uuid
				
	player_inventory.hide()


#----------------------------------------------------------------------------------


# QUEST SYSTEM---------------------------------------------------------------------
signal contraint_passed(quest_uuid, contraint_uuid, node)
signal constraint_failed(quest_uuid, constraint_uuid, node)
signal trigger_activated(quest_uuid, trigger_uuid, node)
signal task_updated(quest_uuid, task_uuid, node)
signal task_completed(quest_uuid, task_uuid, node)
signal task_failed(quest_uuid, task_uuid, node)
signal quest_activated(quest_uuid)
signal quest_completed(quest_uuid)
signal quest_failed(quest_uuid)

var game_quests : Array
var active_quests : Array				# Contains all the active quests

# create all quests for gameplay
func setup_quests():

	for quest in quest_database.data:
		
		# Create quest
		var current = load("res://addons/questie/runtime/quest_system/quest.gd").new()
		current.uuid = quest.uuid
		current.title = quest.title
		current.description = quest.description

		# Subscribe events
		current.connect("state_changed", self, "quest_state_changed")

		# Enlist quest to the game
		game_quests.push_back(current)

		# Activate the quest if no constraints and no triggers
		if quest.constraints.size() == 0 and quest.triggers.size() == 0:
			activate_quest(quest.uuid)


# Get a quest data from quest database
# If no quest is found returns **null**
func get_quest_from_database(var uuid : String)->QuestData: 
	for item in quest_database.data:
		if(item.uuid == uuid): return item
	return null

# Get instantiated quest by UUID
func get_game_quest(var uuid : String)->Quest:

	for quest in game_quests:
		if not quest.uuid == uuid:
			continue

		return quest

	return null
			

func activate_quest(var uuid : String)->void:
	var quest = get_game_quest(uuid)
	if quest == null: return
	
	# activate the new quest if not already active
	if not active_quests.has(quest): 
		quest.change_state(Quest.QuestComplention.ONGOING)

# Called when a trigger is invoked from world/player action.
# When activated the inactive quest shold check all constraints
# If this constraints matches all, the pointed quest will be 
# activated removing the trigger node.
func on_trigger_activated(var quest_uuid : String, var trigger_uuid, var node):

	# Retrieve quest data
	var quest_data = quest_database.get_data(quest_uuid)
	if not quest_data:
		print("[questie]: can't retrieve data from database from quest with uuid: " + quest_uuid)
		return
	
	# Check quest constraints
	if not quest_data.constraints.size() == 0: 
		for constraint in quest_data.constraints:

			if constraint is Constraint_HasItem: 
				var buffer = player_inventory.get_item(constraint.item)
				if not buffer: 
					# Log error
					print("[questie]: player inventory does not has the item to bypass quest constraint")
					emit_signal("constraint_failed", quest_data.uuid, constraint.uuid)
					return
				
				if buffer.uuid == constraint.item and buffer.quantity == constraint.quantity:
					print("[questie]: quest constraint bypassed from player inventory - constraint rule fullfilled")
					emit_signal("contraint_passed", quest_data.uuid, constraint.uuid, null)

			if constraint is Constraint_HasQuest:
				# TODO
				pass
			
			if constraint is Constraint_QuestState:
				# TODO
				pass
	
	# Remove trigger node from parent
	if node.tag == "QN_GetItem":
		player_inventory.remove_child(node)
	
	# TODO: add quest to active_quests
	activate_quest(quest_uuid)

# Manages quest state transitions between game instances and database
func quest_state_changed(var quest_uuid : String, var state : int):

	# Check state
	match state:
		Quest.QuestComplention.ONGOING: 
			quest_activated(quest_uuid)
			#emit_signal("quest_activated", quest_uuid)

		Quest.QuestComplention.COMPLETED:
			pass

		Quest.QuestComplention.FAILED:
			#TODO: quest failed
			pass

# Spawn all quest dependencies 
func quest_activated(var quest_uuid : String):

	var game_quest = get_game_quest(quest_uuid)
	if not game_quest:
		print("[questie]: game quest is not active or spawned - quest/" + game_quest.title)

	# Retrieve quest data from database
	var db_quest = get_quest_from_database(quest_uuid)
	if not db_quest:
		print("[questie]: can't retrieve quest data from database for quest with [uuid]: " + quest_uuid)
		return

	# Spawn quest tasks - TODO: move to function gen_task_nodes()
	for task in db_quest.tasks:

		if task is Task_CollectItem:

			# Generate task-node
			var node = load("res://addons/questie/nodes/collect_item_node.tscn").instance()
			player_inventory.add_child(node)
			node.questie = self
			node.task_uuid = task.uuid
			node.quest_uuid = quest_uuid
			node.item_uuid = task.item_uuid
			node.item_quantity = task.quantity
			
			# Subscribe events
			node.connect("task_updated", self, "task_updated", [quest_uuid, node])		
			node.connect("task_completed", self, "task_completed", [quest_uuid, node])

			game_quest.tasks.push_back(node)
	
	# Log
	print("[questie]: activated quest: " + game_quest.title)

func task_updated(var task_uuid : String, var quest_uuid, var node):
	print("[questie]: task action: update on task:" + task_uuid)
	emit_signal("task_updated", quest_uuid, task_uuid, node)	
	
func task_completed(var task_uuid : String, var quest_uuid : String, var node):
	print("[questie]: task action: complete on task:" + task_uuid)
	emit_signal("task_completed", quest_uuid, task_uuid, node)

	# Check if the quest is completed
	var game_quest = get_game_quest(quest_uuid)
	for task in game_quest.tasks:
		if not task.state == QuestieNode.TaskComplention.COMPLETED:
			return

	quest_completed(quest_uuid, task_uuid)

func quest_completed(var quest_uuid, var task_uuid): 

	var game_quest = get_game_quest(quest_uuid)

	for node in game_quest.tasks:
		node.get_parent().remove_child(node)
	
	game_quest.change_state(Quest.QuestComplention.COMPLETED)
	print("[questie]: quest action: complete on quest:" + quest_uuid)
	
#------------------------------------------------------------------------------------


func _ready(): 

		# initial setup
		setup_inventory()
		setup_quests()

		# Subscribe events
		connect("trigger_activated", self, "on_trigger_activated")
		connect("quest_activated", self, "quest_activated")
