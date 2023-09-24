extends Object
class_name TaskCallbacks_Collect

var quest_database : QuestDatabase = null

func add_listeners(block, data):
    block.connect("category_selected", self, "handle_category_selected", [data])
    block.connect("item_selected", self, "handle_item_selected", [data])
    block.connect("quantity_changed", self, "handle_quantity_changed", [data])

func remove_listeners(block):
    block.disconnect("category_selected", self, "handle_category_selected")
    block.disconnect("item_selected", self, "handle_item_selected")
    block.disconnect("quantity_changed", self, "handle_quantity_changed")

func _init():
    quest_database = ResourceLoader.load("res://questie/quest-db.tres")

func handle_category_selected(category_index, category_id, data):
    data.category_index = category_index
    data.category_id = category_id
    ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func handle_item_selected(item_index, item_id, data):
    data.item_index = item_index
    data.item_id = item_id
    ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func handle_quantity_changed(quantity, data):
    data.quantity = quantity
    ResourceSaver.save("res://questie/quest-db.tres", quest_database)