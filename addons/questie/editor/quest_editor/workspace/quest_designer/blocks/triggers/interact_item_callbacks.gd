extends Object
class_name TriggerCallbacks_InteractItem

var quest_database : QuestDatabase = null
const QUEST_DB_PATH = "res://questie/quest-db.tres"

func add_listeners(block, data):
    block.connect("item_selected", self, "handle_item_selected", [data])
    block.connect("category_selected", self, "handle_category_selected", [data])

func remove_listeners(block):
    block.disconnect("item_selected", self, "handle_item_selected")
    block.disconnect("category_selected", self, "handle_category_selected")

func _init():
    quest_database = ResourceLoader.load(QUEST_DB_PATH)

func handle_item_selected(item_index : int, item_id : String, data):
    data.item_index = item_index
    data.item_id = item_id
    ResourceSaver.save(QUEST_DB_PATH, quest_database)

func handle_category_selected(category_index : int, category_id : String, data):
    data.category_index = category_index
    data.category_id = category_id
    ResourceSaver.save(QUEST_DB_PATH, quest_database)