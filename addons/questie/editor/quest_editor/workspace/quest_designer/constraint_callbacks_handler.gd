tool
extends Object
class_name ConstraintCallbacksHandler

var quest_database : QuestDatabase = null

func _init():
    quest_database = load("res://questie/quest-db.tres")

# @brief                    add a constraint callbacks to the current block
# @param block              the block to observe for changes
# @param data               the constraint data to update
func add_constraint_callbacks(block, data):
    if block is ConstraintBlock_IsLocation:
        block.location_menu.get_popup().connect("id_pressed", self, "handle_is_location_id_changed", [data])

# @brief                    remove constraint callbacks from the current block
# @param block              the graph block where to remove listeners
func remove_constraint_callbacks(block):
    if block is ConstraintBlock_IsLocation:
        block.location_menu.get_popup().disconnect("id_pressed", self, "handle_is_location_id_changed")

func handle_is_location_id_changed(id : int, constraint_data):
    constraint_data.location_id = id
    ResourceSaver.save("res://questie/quest-db.tres", quest_database)
    print("[Questie]: constraint " + constraint_data.uuid + " changed")
    pass
