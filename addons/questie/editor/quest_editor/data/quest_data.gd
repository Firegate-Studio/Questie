# A quest data represent a quest which should be contained inside the database.
# So far, this class represent an asset with persistent data such as the object class.
# Do not try to create a resource asset using "NewResource" command, instead use questie editor unless you know what are you doing.

tool
extends Resource
class_name QuestData

# Track the quest status.
# The possible values are: ONGOING, FAILED, COMPLETED 
enum QuestComplention{
	IDLE,               # Nothing happening 
	ONGOING,            # Activated and running
	FAILED,             # Can't be completed anymore
	COMPLETED           # Completed with success
}

# the unique identifier for a quest item. Each time a new quest data is generated a new id will be generated too.
export(String) var id

# the unique identifier of the parent folder owning the quest item representing the quest itself.
export(String) var parent_folder_id

# the name of the quest inside the quest tree
export(String) var item_name 

# The quest title used during gameplay
export(String) var title = "fill quest title here"

# The status of the quest
# for more details see 'QuestComplention'
export(QuestComplention) var status = QuestComplention.IDLE

# quest description for journal
export(String) var description = "fill quest description here"

# the quest alignment - is a good quest(+) or evil quest(-)?
export(float) var alignment

enum ConstraintType {
	HAS_QUEST,                  # the player must have a specific quest
	HAS_ITEM,                   # the player must own a specific item with a minimum quantity
	IS_LOCATION,				# the player is within a specific location
	QUEST_STATE                 # check the state of activity(complention) of a specific quest,
	HAS_ALIGNMENT				# check the character alignment
}

enum TriggerType{
	ENTER_LOCATION,				# the player enter questie location
	EXIT_LOCATION				# the player exits from location
	GET_ITEM,					# player has an item in inventory
	INTERACT_ITEM,				# player has to interact with an item
	INTERACT_CHARACTER,			# player has to interact with a character
	ALIGNMENT_AMOUNT			# player has to gain the minimum alignment level/points
}

enum TaskType{
	COLLECT_ITEM,				# The player gathered an amount of items
	GO_TO,						# The player has to go to a specific location
	KILL,						# the player has to kill a specific number of characters
	TALK,						# the player has to talk with a specific character
	INTERACT_ITEM,				# the player has to interact with a specific item
	INTERACT_CHARACTER,			# the player has to interact with a specific character
	ALIGNMENT_TARGET			# the player has to achieve a specific alignment amount/points
}

enum RewardType{
	ADD_ITEM 					# Add a specific amount of items as quest reward
	NEW_QUEST					# Activates a new quest as quest reward
	ADD_ALIGNMENT				# Add an amount of alignment points to the character
}

# quest constraints represents rules that should be satisfied 
# to activate a quest when triggered
export(Array, Resource) var constraints

# A trigger represent a rule that must be fullfilled to activate a quest
export(Array, Resource) var triggers

# A task represent an objective that must be fullfilled to complete a quest
# (i.e. kill some mobs or collect a specific item)
export(Array, Resource) var tasks

# A reward represent a gift(reward) after all task will be completed.
# (i.e get experience or items)
export(Array, Resource) var rewards

# @brief                    Add a new constraint to quest data
# @param type               See [ConstraintType] at [res://addons/questie/editor/quest_editor/quest_data.gd] for possible values
# @param owner              The [uuid] of the quest which owns the constraint
func push_constraint(var type : int, var owner : String):
	
	# Prepare data
	var result = null

	# Generate data
	match type:
		ConstraintType.HAS_QUEST: 			
			result = load("res://addons/questie/editor/quest_editor/data/constraint/has_quest_constraint.gd").new()
		ConstraintType.HAS_ITEM:			
			result = load("res://addons/questie/editor/quest_editor/data/constraint/has_item_constraint.gd").new()
		ConstraintType.QUEST_STATE: 		
			result = load("res://addons/questie/editor/quest_editor/data/constraint/quest_state_constraint.gd").new()
		ConstraintType.IS_LOCATION:
			result = load("res://addons/questie/editor/quest_editor/data/constraint/is_location_constraint.gd").new()
		ConstraintType.HAS_ALIGNMENT: 
			result = load("res://addons/questie/editor/quest_editor/data/constraint/has_alignment_constraint.gd").new()
	
	# Generate constraint UUID
	result.uuid = UUID.generate()
	result.owner = owner

	# Add constraint
	constraints.push_back(result)

	# Log
	print("[questie]: generated constraint with [uuid]: " + result.uuid)
	
	return result


# @brief                    Remove constraint data
# @param uuid               The uuid representing the constraint you want purge
func erase_constraint(var uuid):

	# Prepare cached data
	var cache = null

	for item in constraints:

		# Ingnore invalid UUIDs
		if not item.uuid == uuid: continue

		# Get cached item
		cache = item

		# Remove from database
		constraints.erase(item)

	# Check cache validation
	if not cache:

		# Log error
		print("[questie]: can't retrieve cache from constraint with [uuid]: " + uuid)

		return  # Exit with failure

	# Free cached memory
	cache = null

	# Log success
	print("[questie]: freed cached constraint with [uuid]: " + uuid)
	

# @brief                    Get a constraint
# @param uuid               The identifier of the constraint you want get
func get_constraint(var uuid : String):

	if constraints.size() == 0:
		
		# Log error
		print("[questie]: the costraints pool is empty!")

		# Nullify data
		return null

	# Retriveve constraint data
	for item in constraints:

		# Ignore invalid UUIDs
		if not item.uuid == uuid: continue

		return item
	
	# Nullify data
	return null

# @brief					Add a new trigger to quest data
# @param type				The TriggerType
# @param owner				The quest owning this trigger
func push_trigger(var type : int, var owner : String):
	
	var result = null

	match type:
		TriggerType.ALIGNMENT_AMOUNT:
			result = load("res://addons/questie/editor/quest_editor/data/trigger/alignment_amount.gd").new()
		TriggerType.ENTER_LOCATION: 
			result = load("res://addons/questie/editor/quest_editor/data/trigger/enter_location.gd").new()
		TriggerType.EXIT_LOCATION:
			result = load("res://addons/questie/editor/quest_editor/data/trigger/exit_location.gd").new()
		TriggerType.GET_ITEM:
			result = load("res://addons/questie/editor/quest_editor/data/trigger/get_item_trigger.gd").new()
		TriggerType.INTERACT_ITEM:
			result = load("res://addons/questie/editor/quest_editor/data/trigger/item_interaction.gd").new()
		TriggerType.INTERACT_CHARACTER:
			result = load("res://addons/questie/editor/quest_editor/data/trigger/character_interaction.gd").new()
	
	result.owner = owner

	# Add constraint
	triggers.push_back(result)

	# Log
	print("[questie]: generated constraint with [uuid]: " + result.uuid)
		
	return result

func erase_trigger(var uuid : String): 

	var trigger = null

	# Binary search the trigger to remove
	for item in triggers:
		if not item.uuid == uuid: continue
		
		trigger = item
		break
	
	# Remove trigger
	triggers.erase(trigger)
	print("[questie]: removed trigger from quest with uuid: " + uuid)

# @brief					Add a task to the quest
# @param type				the kind of task to add. See quest_data.TaskType for further information
# @param owner				the quest owning this task
func push_task(var type : int, var owner : String):
	var task = null
	match type:
		TaskType.ALIGNMENT_TARGET:
			task = load("res://addons/questie/editor/quest_editor/data/task/alignment_range.gd").new()
		TaskType.COLLECT_ITEM:
			task = load("res://addons/questie/editor/quest_editor/data/task/collect_item_task.gd").new()
		TaskType.GO_TO:
			task = load("res://addons/questie/editor/quest_editor/data/task/go_to_task.gd").new()
		TaskType.KILL:
			task = load("res://addons/questie/editor/quest_editor/data/task/kill_task.gd").new()
		TaskType.TALK:
			task = load("res://addons/questie/editor/quest_editor/data/task/talk_to_task.gd").new()
		TaskType.INTERACT_ITEM:
			task = load("res://addons/questie/editor/quest_editor/data/task/item_interaction.gd").new()
		TaskType.INTERACT_CHARACTER:
			task = load("res://addons/questie/editor/quest_editor/data/task/character_interaction.gd").new()


	if not task:
		# Log error
		print("[questie]: can't generated taks for quest(" + owner + ")")
		return

	task.owner = owner
	tasks.push_back(task)

	# Log
	print("[questie]: generated task with [uuid]: " + task.uuid)

	return task

# @brief					Removes the task from the quest
# @param uuid				the UUID of the taks to remove
func erase_task(var uuid : String):
	var task = null

	for item in tasks:
		if not item.uuid == uuid: continue

		task = item
		break
	
	if not task:
		# Log error
		print("[questie]: can't retrieve data for task with uuid: " + uuid)
		return

	tasks.erase(task)
	print("[questie]: removed task from quest with uuid: " + task.owner)

# @ brief					Binary search for the task at UUID and return it it found
# @param uuid				the task UUID
func get_task(var uuid : String):
	for task in tasks:
		if not task.uuid == uuid: continue
		
		return task	

	return null

# @brief					Add a reward to the quest
# @param type				the kind of reward to add. See quest_data.RewardType for further information
# @param owner				the quest owning this reward
func push_reward(type : int, owner : String):
	var reward = null
	match type:
		RewardType.ADD_ITEM: 
			reward = load("res://addons/questie/editor/quest_editor/data/reward/add_item_reward.gd").new()

		RewardType.NEW_QUEST:
			reward = load("res://addons/questie/editor/quest_editor/data/reward/new_quest_reward.gd").new()
	
	if not reward:
		# Log error
		print("[questie]: can't generated taks for quest(" + owner + ")")
		return

	reward.owner = owner
	rewards.push_back(reward)

	# Log
	print("[questie]: generated task with [uuid]: " + reward.uuid)

	return reward

# @brief					Removes a reward from the quest
# @param uuid				the UUID of the reward to remove
func erase_reward(uuid : String):
	var reward = null

	for item in rewards:
		if not item.uuid == uuid: continue

		reward = item
		break
	
	if not reward:
		# Log error
		print("[questie]: can't retrieve data for task with uuid: " + uuid)
		return

	rewards.erase(reward)
	print("[questie]: removed task from quest with uuid: " + reward.owner)

# @ brief					Binary search for the reward at UUID and return it if found
# @param uuid				the reward UUID	
func get_reward(uuid : String):
	for reward in rewards:
		if not reward.uuid == uuid: continue
		
		return reward	

	return null
