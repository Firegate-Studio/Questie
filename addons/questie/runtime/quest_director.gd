# The [QuestDirector] is a component that manages the database quests
extends Node
class_name QuestDirector

# A reference to the quest database
var quest_database : QuestDatabase

# Contains all the active quests
var active_quests : Array

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

func _ready(): 
    if quest_database == null:
        quest_database = load("res://questie/quest-db.tres")