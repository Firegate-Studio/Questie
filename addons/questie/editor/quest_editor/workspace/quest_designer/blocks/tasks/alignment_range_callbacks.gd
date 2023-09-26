extends Object
class_name TaskCallbacks_AlignmentRange

var quest_database : QuestDatabase = null
const QUEST_DB_PATH = "res://questie/quest-db.tres"

func add_listeners(block, data):
	block.connect("alignment_range_changed", self, "handle_alignmnet_range_changed", [data])

func remove_listeners(block):
	block.disconnect("alignment_range_changed", self, "handle_alignmnet_range_changed")

func _init():
	quest_database = ResourceLoader.load(QUEST_DB_PATH)
	if not quest_database:
		print("[Questie]: Can't load quest database for TaskCallbacks_AlignmentRange")
		return

func handle_alignmnet_range_changed(current_min, current_max, data):
	data.min_value = current_min
	data.max_value = current_max
	ResourceSaver.save(QUEST_DB_PATH, quest_database)
