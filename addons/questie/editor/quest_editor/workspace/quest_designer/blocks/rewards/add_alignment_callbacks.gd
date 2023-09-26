extends Object
class_name RewardCallbacks_AddAlignment

var quest_db : QuestDatabase = null
const QUEST_DB_PATH = "res://questie/quest-db.tres"

func add_listeners(block, data):
    block.connect("alignment_changed", self, "handle_alignment_changed", [data])

func remove_listeners(block):
    block.disconnect("alignment_changed", self, "handle_alignment_changed")

func _init():
    quest_db = ResourceLoader.load(QUEST_DB_PATH)
    if not quest_db:
        print("[Questie]: Can't load quest database for RewardCallbacks_AddAlignment")
        return

func handle_alignment_changed(alignment, data):
    data.alignment_amount = alignment
    ResourceSaver.save(QUEST_DB_PATH, quest_db)