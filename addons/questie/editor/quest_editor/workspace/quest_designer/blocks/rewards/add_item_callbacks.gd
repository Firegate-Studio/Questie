extends Object
class_name RewardCallbacks_AddItem

var quest_db : QuestDatabase = null
const QUEST_DB_PATH = "res://questie/quest-db.tres"

func add_listeners(block, data):
    block.connect("quantity_changed", self, "handle_quantity_changed", [data])
    block.connect("category_selected", self, "handle_category_selected", [data])
    block.connect("item_selected", self, "handle_item_selected", [data])

func remove_listeners(block):
    block.disconnect("quantity_changed", self, "handle_quantity_changed")
    block.disconnect("category_selected", self, "handle_category_selected")
    block.disconnect("item_selected", self, "handle_item_selected")

func _init():
    quest_db = ResourceLoader.load(QUEST_DB_PATH)
    if not quest_db:
        print("[Questie]: Can't load quest database for RewardCallbacks_AddItem")
        return

func handle_quantity_changed(quantity : int, data):
    data.item_quantity = quantity
    ResourceSaver.save(QUEST_DB_PATH, quest_db)

func handle_category_selected(category_index : int, category_id : String, data):
    data.category_index = category_index
    data.category_id = category_id
    ResourceSaver.save(QUEST_DB_PATH, quest_db)

func handle_item_selected(item_index : int, item_id : String, data):
    data.item_index = item_index
    data.item_id = item_id
    ResourceSaver.save(QUEST_DB_PATH, quest_db)