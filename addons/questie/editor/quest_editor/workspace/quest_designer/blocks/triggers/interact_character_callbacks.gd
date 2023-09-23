extends Object
class_name TriggerCallbacks_InteractCharacter

var quest_database : QuestDatabase = null
const QUEST_DB_PATH = "res://questie/quest-db.tres"

func add_listeners(block, data):
    block.connect("character_selected", self, "handle_character_selected", [data])

func remove_listeners(block):
    block.disconnect("character_selected", self, "handle_character_selected")

func _init():
    quest_database = ResourceLoader.load(QUEST_DB_PATH)

func handle_character_selected(character_index : int, character_id : String, data):
    data.character_idx = character_index
    data.character_id = character_id
    ResourceSaver.save(QUEST_DB_PATH, quest_database)