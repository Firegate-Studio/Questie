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
	player_inventory = load(settings.items_settings.inventory).instance()
	add_child(player_inventory)

	for quest in quest_database.data:
		
		for constraint in quest.constraints:

			if constraint is Constraint_HasItem:
				# TODO: has_item node
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
signal task_completed(quest_uuid, task_uuid, node)
signal task_failed(quest_uuid, task_uuid, node)
signal quest_activated(quest_uuid)
signal quest_completed(quest_uuid)
signal quest_failed(quest_uuid)

var active_quests : Array				# Contains all the active quests

# Get a quest data from quest database
# If no quest is found returns **null**
func get_quest(var uuid : String)->QuestData: 
	for item in quest_database.data:
		if(item.uuid == uuid): return item
	return null

func activate_quest(var uuid : String)->void:
	var quest = get_quest(uuid)
	if quest == null: return
	
	# activate the new quest if not already active
	if not active_quests.has(quest): active_quests.push_back(quest)

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
	else:
		print("not trigger!")
	
	# TODO: set trigger to completed
	# TODO: add quest to active_quests
	# Log quest activation
	print("[questie]: activated quest: " + quest_data.title)

#------------------------------------------------------------------------------------


func _ready(): 

		# initial setup
		setup_inventory()

		# Subscribe events
		connect("trigger_activated", self, "on_trigger_activated")
