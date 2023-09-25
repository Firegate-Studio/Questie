extends Object
class_name TaskCallbacks_Kill

var quest_database : QuestDatabase = null
const QUEST_DB_PATH = "res://questie/quest-db.tres"

func add_listeners(block, data):
    block.connect("character_selected", self, "handle_character_selected", [data])
    block.connect("quantity_changed", self, "handle_quantity_changed", [data])

func remove_listeners(block):
    block.disconnect("character_selected", self, "handle_character_selected")
    block.disconnect("quantity_changed", self, "handle_quantity_changed")

func _init():
    quest_database = ResourceLoader.load(QUEST_DB_PATH)
    if not quest_database:
        print("[Questie]: Can't load quest database for TaskCallbacks_Kill")
        return

func handle_character_selected(character_index : int, character_id : String, data):
    data.character_index = character_index
    data.character_id = character_id
    ResourceSaver.save(QUEST_DB_PATH, quest_database)

func handle_quantity_changed(quantity : int, data):
    data.target_kills = quantity
    ResourceSaver.save(QUEST_DB_PATH, quest_database)