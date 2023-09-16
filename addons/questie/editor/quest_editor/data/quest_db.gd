tool
extends Resource
class_name QuestDatabase, "res://addons/questie/editor/icons/database.png"

# The database identifier. 
# When you generate a [QuestDB]; the [uuid] will be generated automatically.
export(String) var uuid

export(Array, Resource) var folders  

# A list of all quest contained inside the quest database
export(Array, Resource) var quests

# @brief add a new folder to the database
# @param data the folder data
func push_folder(data):
	folders.append(data)
	print("[Questie]: added folder " + data.id)

# @brief remove a folder from database
# @param id the identifier of the folder to remove
func erase_folder(id : String):
	for folder in folders:
		if not folder.id == id: continue

		folders.erase(folder)
		print("[Questie]: removed folder " + id)

# Add a new quest to the database with default values
func push_new_quest(data : QuestData): 
	quests.append(data)

# Remove a quest from the quest database
func erase_quest(var id : String)->void: 
	for item in quests:
		if item.id == id: 
			quests.erase(item)
			print("[questie]: removed quest with uuid(" + id+")")
			return
	print("[questie]: can't find a quest with the following uuid("+id+")")

# @brief removes all stored data
func purge():
	quests.clear()

# @brief				Get the quest data throw [id]
# @param [id]			the [id] owned from the quest you want get
func get_quest_data(var id : String)->QuestData:
	for item in quests:
		if item.id == id: return item
	return null
	
func get_folder_data(folder_id : String):
	for data in folders:
		if not data.id == folder_id: continue
		
		return data
	return null
		
