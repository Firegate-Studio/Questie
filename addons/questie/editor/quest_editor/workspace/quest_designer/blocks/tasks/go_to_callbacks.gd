extends Object
class_name TaskCallbacks_GoTo

var quest_database : QuestDatabase = null
const QUEST_DB_PATH = "res://questie/quest-db.tres"

func add_listeners(block, data):
    block.connect("region_selected", self, "handle_region_selected", [data])
    block.connect("location_selected", self, "handle_location_selected", [data])

func remove_listeners(block):
    block.disconnect("region_selected", self, "handle_region_selected")
    block.disconnect("location_selected", self, "handle_location_selected")

func _init():
    quest_database = ResourceLoader.load(QUEST_DB_PATH)

func handle_region_selected(region_index : int, region_id : String, data):
    data.category_index = region_index
    data.category_id = region_id
    ResourceSaver.save(QUEST_DB_PATH, quest_database)

func handle_location_selected(location_index : int, location_id : String, data):
    data.location_index = location_index
    data.location_id = location_id
    ResourceSaver.save(QUEST_DB_PATH, quest_database)