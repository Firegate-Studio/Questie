# The [QuestDirector] is a component that manages the database quests
class_name Questie, "res://addons/questie/editor/icons/director.png"
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
		print("[questie]: player inventory is not set - reload your inventory using the settings editor")
		return
	
	player_inventory = load(settings.items_settings.inventory).instance()
	add_child(player_inventory)
				
	player_inventory.hide()


#----------------------------------------------------------------------------------


# QUEST SYSTEM---------------------------------------------------------------------
# called when a quest constraint bypass the check
signal contraint_passed(quest_uuid, contraint_uuid, node)
# called when a quest constraint fails to bypass rule check
signal constraint_failed(quest_uuid, constraint_uuid, node)
# called when a quest trigger is activated
signal trigger_activated(quest_uuid, trigger_uuid, node)
# called when a quest task is updated
signal task_updated(quest_uuid, task_uuid, node)
# called when a quest task is completed
signal task_completed(quest_uuid, task_uuid, node)
# called when a quest task fails
signal task_failed(quest_uuid, task_uuid, node)
# called when a new quest is activated
signal quest_activated(quest_uuid)
# called when a quest is completed
signal quest_completed(quest_uuid)
# called when a quest fails
signal quest_failed(quest_uuid)

# called when generating constraints
signal generate_constraints(constraint_data)
# called when generating triggers
signal generate_triggers(trigger_data)
# called when generating tasks
signal generate_tasks(task_data)
# called when generating rewards
signal generate_rewards(reward_data)

var game_quests : Array
var active_quests : Array				# Contains all the active quests
var completed_quests = {}				# Contains the quest id and releated quest node (i.e., completed_quest[quest_id] = QuestNodeInstance)
var failed_quests = {}

var constraints = {}
var triggers = {}
var tasks = {}
var rewards = {}

# create or load all quests nodes
func setup_quests():

	# todo: quest saves should loded here

	for quest in quest_database.data:
		
		# Create quest
		var current = load("res://addons/questie/runtime/quest_system/quest.gd").new()
		current.uuid = quest.uuid
		current.title = quest.title
		current.description = quest.description

		# subscribe events
		current.connect("state_changed", self, "handle_quest_state_changed")
		current.connect("constraint_added", self, "handle_quest_constraint_added", [current.uuid])
		current.connect("constraint_removed", self, "handle_quest_constraint_removed", [current.uuid])
		current.connect("trigger_added", self, "handle_quest_trigger_added", [current.uuid])
		current.connect("trigger_removed", self, "handle_quest_trigger_removed", [current.uuid])
		current.connect("task_added", self, "handle_quest_task_added", [current.uuid])
		current.connect("task_removed", self, "handle_quest_task_removed", [current.uuid])
		current.connect("reward_added", self, "handle_quest_reward_added", [current.uuid])
		current.connect("reward_removed", self, "handle_quest_reward_removed", [current.uuid])

		# record constraint identifiers
		for constraint in quest.constraints:
			current.add_constraint(constraint.uuid)

		# record trigger identifiers
		for trigger in quest.triggers: 
			current.add_trigger(trigger.uuid)

		# record task identifiers
		for task in quest.tasks:
			current.add_task(task.uuid)

		# record reward identifiers
		for reward in quest.rewards:
			current.add_reward(reward.uuid)

		# Enlist quest to the game
		game_quests.push_back(current)

# create or load constraint nodes
func setup_constraints(constraint_id, quest_id, quest_data): 
	for constraint_data in quest_data.constraints:

		if constraint_data is Constraint_HasItem:
			var constraint_node = ConstraintNodeBuilder.has_item_node(constraint_data, constraint_id, quest_id, player_inventory)
			constraint_node.connect("constraint_passed", self, "handle_quest_constraint_bypassed")
			constraint_node.connect("constraint_failed", self, "handle_quest_constraint_failed")
			constraints[constraint_id] = constraint_node
			add_child(constraint_node)

		if constraint_data is Constraint_QuestState: 
			var quest = get_game_quest(constraint_data.quest)
			if not quest: 
				print("[Questie]: can not retrieve quest node with identifier: " + quest_id + " while creating constraints")
				return

			var constraint_node = ConstraintNodeBuilder.quest_state_node(constraint_data, constraint_id, quest_id, quest)
			constraint_node.connect("constraint_passed", self, "handle_quest_constraint_bypassed")
			constraint_node.connect("constraint_failed", self, "handle_quest_constraint_failed")
			constraints[constraint_id] = constraint_node
			add_child(constraint_node)

		if constraint_data is Constraint_HasQuest:
			var quest = get_game_quest(constraint_data.quest)
			if not quest: 
				print("[Questie]: can not retrieve quest node with identifier: " + quest_id + " while creating constraints")
				return

			var constraint_node = ConstraintNodeBuilder.has_quest_node(constraint_data, constraint_id, quest_id, quest)
			constraint_node.connect("constraint_passed", self, "handle_quest_constraint_bypassed")
			constraint_node.connect("constraint_failed", self, "handle_quest_constraint_failed")
			constraints[constraint_id] = constraint_node
			add_child(constraint_node)

		emit_signal("generate_constraints", constraint_data)

# create or load all trigger nodes
func setup_triggers(trigger_id, quest_id, quest_data):

	for trigger_data in quest_data.triggers:

		if trigger_data is Trigger_GetItem:
			
			var trigger_node = TriggerNodeBuilder.get_item_node(trigger_data, trigger_id, quest_id, player_inventory)
			trigger_node.connect("trigger_activated", self, "handle_quest_trigger_activated")
			triggers[trigger_id] = trigger_node
			add_child(trigger_node)	

		emit_signal("generate_triggers", trigger_data)

# create or load all task nodes
func setup_tasks(task_id, quest_id, quest_data):
	

	for task_data in quest_data.tasks:
		
		if not task_data.uuid == task_id: continue

		print("[Questie]: generating task " + task_id + "for quest with identifier: " + quest_id)

		if task_data is Task_CollectItem:
			var task_node = TaskNodeBuilder.collect_item_node(task_data, task_id, quest_id, player_inventory)
			task_node.connect("task_completed", self, "handle_quest_task_completed")
			task_node.connect("task_updated", self, "handle_quest_task_updated")
			tasks[task_id] = task_node
			add_child(task_node)

		emit_signal("generate_tasks", task_data)

# create or load all reward nodes
func setup_rewards(reward_id, quest_id, quest_data): 
	for reward_data in quest_data.rewards:

		if not reward_data.uuid == reward_id: continue

		if reward_data is Reward_AddItem:
			var reward_node = RewardNodeBuilder.add_item_node(reward_data, reward_id, quest_id, player_inventory)
			connect("quest_completed", reward_node, "complete")
			rewards[reward_id] = reward_node
			add_child(reward_node)

		if reward_data is Reward_NewQuest:
			var reward_node = RewardNodeBuilder.new_quest_node(reward_data, reward_id, quest_id)
			connect("quest_completed", reward_node, "complete")
			reward_node.connect("activate_quest", self, "activate_quest")
			rewards[reward_id] = reward_node
			add_child(reward_node)

		emit_signal("generate_rewards", reward_data)

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
			
func get_active_quest(quest_id : String)->Quest:

	for quest_node in active_quests:
		if not quest_node.uuid == quest_id: continue

		return quest_node

	return null

func get_completed_quest(quest_id : String)->Quest:

	if completed_quests.size() == 0: return null
	if not completed_quests.has(quest_id): return null
	return completed_quests[quest_id]

func activate_quest(var uuid : String)->void:
	var quest = get_game_quest(uuid)
	if quest == null: return
	
	# activate the new quest if not already active
	if not active_quests.has(quest): 
		destroy_all_quest_constraints(quest)
		destroy_all_quest_triggers(quest)
		activate_all_quest_tasks(quest)
		game_quests.erase(quest)
		active_quests.append(quest)
		quest.change_state(Quest.QuestComplention.ONGOING)
		emit_signal("quest_activated", uuid)

func activate_all_quest_tasks(quest_node):

	for task_id in quest_node.tasks:

		if not tasks[task_id]:
			print("[Questie]: can not retrieve quest node from tasks table for task with identifier: " + task_id)
			return

		var task_node = tasks[task_id]

		# activate task
		task_node.state = QuestieNode.TaskComplention.ONGOING

func complete_quest(quest_node):

	var id = quest_node.uuid
	active_quests.erase(quest_node)
	completed_quests.append(quest_node)
	destroy_all_quest_tasks(quest_node)

# check if all quest constraint has been fulfilled
func all_quest_constraints_bypassed(quest_node)->bool:

	if quest_node.constraints.size() == 0: return true

	for constraint_id in quest_node.constraints:
		
		if not constraints[constraint_id].bypassed: return false

	return true

# check if all quest triggers has been passed rule check
func all_quest_triggers_completed(quest_node)->bool:

	# BUG: for some reason this command ever activates the quest ignoring triggers rules
	if quest_node.triggers.size() == 0: return true

	for trigger_id in quest_node.triggers:

		if not triggers.has(trigger_id):
			print("[Questie]: can not retrieve trigger node from triggers table for trigger with key: " + trigger_id)
			return false

		var trigger_node = triggers[trigger_id]
		if not trigger_node.state == QuestieNode.TaskComplention.COMPLETED: return false

	return true

# check if all quest task has been completed
func all_quest_task_completed(quest_node)->bool:

	if quest_node.tasks.size() == 0: return true

	for task_id in quest_node.tasks:

		if not tasks[task_id].state == QuestieNode.TaskComplention.COMPLETED: return false

	return true

func destroy_all_quest_constraints(quest_node):
	for id in quest_node.constraints:
		if not constraints.has(id):
			print("[Questie]: constraint node was not found in constraint table for constraint with identifier: " + id)
			return

		var deleting_constraint = constraints[id]
		constraints.erase(id)
		deleting_constraint.queue_free()
		print("[Questie]: removed constraint [" + id + "] from quest [" + quest_node.title + "]")

func destroy_all_quest_triggers(quest_node):
	for id in quest_node.triggers:
		if not triggers.has(id):
			print("[Questie]: can not retrieve trigger node for node with identifier: " + id)
			return
		
		# destroy trigger node
		var trigger_node = triggers[id]
		triggers.erase(id)
		trigger_node.queue_free()
		print("[Questie]: detroyed trigger [" + id + "] from quest [" + quest_node.title + "]")

func destroy_all_quest_tasks(quest_node):
	for id in quest_node.tasks:
		if not tasks.has(id):
			print("[Questie]: can not retrieve trigger node with id " + id + " from quest [" + quest_node.title + "]")
			return

		var task_node = tasks[id]
		tasks.erase(id)
		task_node.queue_free()
		print("[Questie]: detroyed task node [" + id + "] from quest [" + quest_node.title + "]")

# check if a quest meets all requirements for activation
func can_activate_quest(quest_node)->bool:

	if not all_quest_constraints_bypassed(quest_node): 
		print("[Questie]: constraint check not bypassed for quest: " + quest_node.uuid)
		return false
	if not all_quest_triggers_completed(quest_node): 
		print("[Questie]: trigger check rule not fulfilled for quest: " + quest_node.uuid)
		return false

	return true

# check if a quest can be completed - has finished all required tasks
func can_complete_quest(quest_node)->bool:

	if quest_node.tasks.size() ==0: return true

	for task_id in quest_node.tasks:

		if not tasks.has(task_id):
			print("[Questie]: can not retrieve task node from task table for task with identifier: " + task_id)
			return false
		
		# retrieve task node
		var task_node = tasks[task_id]

		if not task_node.state == QuestieNode.TaskComplention.COMPLETED: 
			return false

	print("[Questie]: all tasks completed for quest [" + quest_node.title + "]")
	return true

#-----------------------------------------------------------------------------------
# CALLBACKS
#-----------------------------------------------------------------------------------
func handle_quest_constraint_added(constraint_id, quest_id): 

	# retrieve quest from database
	var quest_data = get_quest_from_database(quest_id)
	if not quest_data: 
		print("[Questie]: can not retrieve quest information for quest with id: " + quest_id)
		return

	setup_constraints(constraint_id, quest_id, quest_data)
	
func handle_quest_trigger_added(trigger_id, quest_id): 

	var quest_data = get_quest_from_database(quest_id)
	if not quest_data:
		print("[Questie]: can not retireve information for quest with id: " + quest_id)
		return

	setup_triggers(trigger_id, quest_id, quest_data)

func handle_quest_task_added(task_id, quest_id): 

	var quest_data = get_quest_from_database(quest_id)
	if not quest_data:
		print("[Questie]: can not retrieve information from quest with id: " + quest_id)
		return

	setup_tasks(task_id, quest_id, quest_data)
	
func handle_quest_reward_added(reward_id, quest_id): 

	var quest_data = get_quest_from_database(quest_id)
	if not quest_data:
		print("[Questie]: can not retrieve information from quest with id: " + quest_id)
		return

	setup_rewards(reward_id, quest_id, quest_data)

func handle_quest_constraint_removed(constraint_id, quest_id): pass
func handle_quest_trigger_removed(trigger_id, quest_id): pass
func handle_quest_task_removed(task_id, quest_id): pass
func handle_quest_reward_removed(reward_id, quest_id): pass

func handle_quest_state_changed(quest_id, state): 

	var quest_node = get_active_quest(quest_id)
	if not quest_node:
		print("[Questie]: active quest node not found for quest with identifier: " + quest_id)
		return
	
	match state:
		Quest.QuestComplention.ONGOING:
			print("[Questie]: activated quest [" + quest_node.title + "]")
			
		Quest.QuestComplention.FAILED: 
			active_quests.erase(quest_node)
			failed_quests[quest_id] = quest_node
			print("[Questie]: failed quest [" + quest_node.title + "]")
			emit_signal("quest_failed", quest_id)

		Quest.QuestComplention.COMPLETED:
			active_quests.erase(quest_node)
			completed_quests[quest_id] = quest_node
			print("[Questie]: completed quest ["+ quest_node.title + "]")
			emit_signal("quest_completed", quest_id)

func handle_quest_constraint_bypassed(constraint_id): 

	print("[Questie]: quest constraint check rule bypassed for constraint with identifier: " + constraint_id)

	if not constraints.has(constraint_id):
		print("[Questie]: can not find constraint node with identifier: " + constraint_id + " from constraints table")
		return

	var constraint_node = constraints[constraint_id]
	
	# retrieve constraint owner(quest node)
	var quest_id = constraint_node.quest_id
	var quest_node = get_game_quest(quest_id)
	if not quest_node:
		print("[Questie]: can not retrieve quest node with identifier: " + constraint_id + " for constraint rule check")
		return

	if not can_activate_quest(quest_node): 
		return

	activate_quest(quest_id)

func handle_quest_constraint_failed(constraint_id): 
	print("[Questie]: constraint check rule failed for constraint with identifier: " + constraint_id)

# called when a trigger receive activation
func handle_quest_trigger_activated(trigger_id): 

	var trigger_node = triggers[trigger_id]
	if not trigger_node:
		print("[Questie]: can not find trigger node at the give key in table: " + trigger_id)
	
	# get quest owner
	var quest_id = trigger_node.quest_id
	var quest_node = get_game_quest(trigger_node.quest_id)
	if not quest_node:
		print("[Questie]: can not find quest node at the given key in table: " + trigger_node.quest_id)
		return

	if not can_activate_quest(quest_node): return
	
	activate_quest(quest_id)

# called when a quest task is completed
func handle_quest_task_completed(task_id): 

	if not tasks.has(task_id): 
		print("[Questie]: can not find task with identifier [" + task_id + "] from tasks table")
		return
	
	var task_node = tasks[task_id]
	var quest_id = task_node.quest_id
	var quest_node = get_active_quest(task_node.quest_id)
	if not quest_node:
		print("[Questie]: can not find task node with identifier: " + task_node.quest_id)
		return

	print("[Questie]: completed task with identifier: " + task_id)

	if not can_complete_quest(quest_node): 
		return
	
	print("[Questie]: change quest state to [" + var2str(Quest.QuestComplention.COMPLETED) + "]")
	quest_node.change_state(Quest.QuestComplention.COMPLETED)

# called when a quest task is updated
func handle_quest_task_updated(task_id): 

	if not tasks.has(task_id):
		print("[Questie]: can not retrieve quest node from tasks table for task with identifier: " + task_id)
		return

	var task_node = tasks[task_id]
	if not task_node:
		print("[Questie]: can not find task node with identifier: " + task_id)
		return

	var quest_id = task_node.quest_id
	var quest_node = get_active_quest(task_node.quest_id)
	if not quest_node:
		print("[Questie]: can not find quest node with identifier: " + task_id)
		return

	print("[Questie]: updated task [" + task_id + "] for quest ["+quest_node.title+"]")

#------------------------------------------------------------------------------------

func _ready(): 

		# initial setup
		setup_inventory()

		# quest system
		setup_quests()

		# activate all triggerable quests
		for quest_node in game_quests:

			if not can_activate_quest(quest_node): continue

			activate_quest(quest_node.uuid)

