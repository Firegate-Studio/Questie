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
    data.push_back(result)
    return result

# **TODO**: this function is not ported yet.
func erase_quest(var quest : String)->void: pass

    
        
