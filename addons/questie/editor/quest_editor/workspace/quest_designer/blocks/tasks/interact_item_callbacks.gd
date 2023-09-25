extends Object
class_name TaskCallbacks_InteractItem

var quest_database : QuestDatabase = null
const QUEST_DB_PATH = "res://questie/quest-db.tres"

func add_listeners(block, data):
    block.connect("category_selected", self, "handle_category_selected", [data])
    block.connect("item_selected", self, "handle_item_selected", [data])

func remove_listeners(block):
    block.disconnect("category_selected", self, "handle_category_selected")
    block.disconnect("item_selected", self, "handle_item_selected")

func _init():
    quest_database = ResourceLoader.load(QUEST_DB_PATH)
    if not quest_database:
        print("[Questie]: Can't load quest database for TaskCallbacks_InteractItem")
        return

func handle_category_selected(category_index : int, category_id : String, data):
    data.category_index = category_index
    data.category_id = category_id
    ResourceSaver.save(QUEST_DB_PATH, quest_database)

func handle_item_selected(item_index : int, item_id : String, data):
    data.item_index = item_index
    data.item_id = item_id
    ResourceSaver.save(QUEST_DB_PATH, quest_database)