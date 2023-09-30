tool
extends Object
class_name ConstraintCallbacksHandler

var quest_database : QuestDatabase = null
var item_database : ItemDatabase = null

func _init():
	quest_database = ResourceLoader.load("res://questie/quest-db.tres")
	if not quest_database:
		print("[Questie]: unable to load quest database")
		return

	item_database = ResourceLoader.load("res://questie/item-db.tres")
	if not item_database:
		print("[Questie]: unable to load item database")
		return


# @brief                    add a constraint callbacks to the current block
# @param block              the block to observe for changes
# @param data               the constraint data to update
func add_constraint_callbacks(block, data):
	if block is ConstraintBlock_IsLocation:
		block.location_menu.get_popup().connect("id_pressed", self, "handle_is_location_id_changed", [data])
	
	if block is ConstraintBlock_HasItem:
		block.item_menu.get_popup().connect("id_pressed", self, "handle_has_item_target_id_changed", [data])
		block.item_quantity.connect("value_changed", self, "handle_has_item_quantity_changed", [data])

	if block is ConstraintBlock_HasAlignment:
		block.connect("character_alignment_changed", self, "handle_has_alignment_range_changed", [data])
		block.connect("character_id_changed", self, "handle_has_alignment_character_id_changed", [data])

# @brief                    remove constraint callbacks from the current block
# @param block              the graph block where to remove listeners
func remove_constraint_callbacks(block):
	if block is ConstraintBlock_IsLocation:
		block.location_menu.get_popup().disconnect("id_pressed", self, "handle_is_location_id_changed")

	if block is ConstraintBlock_HasItem:
		block.item_menu.get_popup().disconnect("id_pressed", self, "handle_has_item_target_id_changed")
		block.item_quantity.disconnect("value_changed", self, "handle_has_item_quantity_changed")

	if block is ConstraintBlock_HasAlignment:
		block.disconnect("character_alignment_changed", self, "handle_has_alignment_range_changed")
		block.disconnect("character_id_changed", self, "handle_has_alignment_character_id_changed")

func handle_is_location_id_changed(id : int, constraint_data):
	constraint_data.location_id = id
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)
	print("[Questie]: constraint " + constraint_data.uuid + " changed")
	pass

func handle_has_item_target_id_changed(index: int, constraint_data):
	constraint_data.item_id = item_database.items[index].id
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func handle_has_item_quantity_changed(quantity : int, constraint_data):
	constraint_data.quantity = quantity
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func handle_has_alignment_range_changed(min_alignment, max_alignment, constraint_data):
	constraint_data.min_alignment = min_alignment
	constraint_data.max_alignment = max_alignment
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func handle_has_alignment_character_id_changed(character_id, constraint_data):
	constraint_data.character_id = character_id
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)
