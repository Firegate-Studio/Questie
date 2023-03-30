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

# the unique identifier for a quest item. Each time a new quest data is generated a new uuid will be generated too.
export(String) var uuid

# The quest title
export(String) var title = "fill quest title here"

# The status of the quest
# for more details see 'QuestComplention'
export(QuestComplention) var status = QuestComplention.IDLE

# quest description for journal
export(String) var description = "fill quest description here"

enum ConstraintType {
	HAS_QUEST,                  # the player must have a specific quest
	HAS_ITEM,                   # the player must own a specific item with a minimum quantity
	QUEST_STATE                 # check the state of activity(complention) of a specific quest
}

enum TriggerType{
	IS_LOCATION,				# Change to Enter Location
	EXIT_LOCATION				# the player enters to location
	GET_ITEM					# player has an item in inventory
}

enum TaskType{
	COLLECT_ITEM				# The player gathered an amount of items
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
			result = load("res://addons/questie/editor/quest_editor/has_quest_constraint.gd").new()
		ConstraintType.HAS_ITEM:			
			result = load("res://addons/questie/editor/quest_editor/has_item_constraint.gd").new()
		ConstraintType.QUEST_STATE: 		
			result = load("res://addons/questie/editor/quest_editor/quest_state_constraint.gd").new()
	
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

# @brief					push a new 
func push_trigger(var type : int, var owner : String):
	
	var result = null

	match type:
		TriggerType.IS_LOCATION: 
			print("[questie]: TODO:QuestData.IsLocation")
		TriggerType.GET_ITEM:
			result = load("res://addons/questie/editor/quest_editor/get_item_trigger.gd").new()
	
	result.trigger_owner = owner

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
		TaskType.COLLECT_ITEM:
			task = load("res://addons/questie/editor/quest_editor/collect_item_task.gd").new()


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
