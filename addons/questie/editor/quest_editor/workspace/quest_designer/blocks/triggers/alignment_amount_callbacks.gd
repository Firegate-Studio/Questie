extends Object
class_name TriggerCallbacks_AlignmentAmount

var quest_database : QuestDatabase = null

func add_listeners(block, data):
    block.connect("alignment_range_changed", self, "handle_alignment_range_changed", [data])

func remove_listeners(block):
    block.disconnect("alignment_range_changed", self, "handle_alignment_range_changed")

func _init():
    quest_database = ResourceLoader.load("res://questie/quest-db.tres")

func handle_alignment_range_changed(current_min : float, current_max : float, data):
    data.min_value = current_min
    data.max_value = current_max
    ResourceSaver.save("res://questie/quest-db.tres", quest_database)