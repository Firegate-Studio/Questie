# The 'QuestDatabase' is an asset responsable for quest creation and management.
# Do not try to create the 'QuestDatabase' using 'NewResource' command, instead use 'QuestieEditorTool' for creating it.
# NOTE: EACH GAME SHOULD HAS ONLY 1 QUEST DB.

tool
extends Resource
class_name QuestDatabase

# The database identifier. 
# When you generate a [QuestDB]; the [uuid] will be generated automatically.
export(String) var uuid

# A list of all quest contained inside the quest database
export(Array, Resource) var data

# Add a new quest to the database with default values
func push_new_quest()->QuestData: 
	var result : QuestData = QuestData.new()
	result.uuid = UUID.generate()
	data.push_back(result)
	print("[questie]: new quest created")
	return result

# Remove a quest from the quest database
func erase_quest(var uuid : String)->void: 
	for item in data:
		if item.uuid == uuid: 
			data.erase(item)
			print("[questie]: removed quest with uuid(" + uuid+")")
			return
	print("[questie]: can't find a quest with the following uuid("+uuid+")")

# @brief removes all stored data
func purge():
	data.clear()
	

	
		
