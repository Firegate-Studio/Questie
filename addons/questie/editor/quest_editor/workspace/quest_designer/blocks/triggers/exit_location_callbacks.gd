extends Object
class_name TriggerCallbacks_CharacterExitLocation

var quest_database : QuestDatabase

func add_listeners(block, data):
    block.connect("character_selected", self, "handle_character_selected", [data])
    block.connect("region_selected", self, "handle_region_selected", [data])
    block.connect("location_selected", self, "handle_location_selected", [data])

func remove_listeners(block):
    block.disconnect("character_selected", self, "handle_character_selected")
    block.disconnect("region_selected", self, "handle_region_selected")
    block.disconnect("location_selected", self, "handle_location_selected")

func _init():
    quest_database = ResourceLoader.load("res://questie/quest-db.tres")

func handle_character_selected(character_index : int, character_id : String, data):
    data.character_index = character_index
    data.character_id = character_id
    ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func handle_region_selected(region_index : int, region_id : String, data):
    data.category_index = region_index
    data.category_id = region_id
    ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func handle_location_selected(location_index : int, location_id : String, data):
    data.location_index = location_index
    data.location_id = location_id
    ResourceSaver.save("res://questie/quest-db.tres", quest_database)