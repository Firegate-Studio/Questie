tool
extends GraphNode
class_name RewardBlock_AddItem

signal quantity_changed(quantity)
signal category_selected(category_index, category_id)
signal item_selected(item_index, item_id)

var item_db : ItemDatabase = null

var current_quantity : int = 1

var selected_category_index : int = -1
var selected_category_id : String

var selected_item_index : int = -1
var selected_item_id : String

var quantity_box : SpinBox
var category_menu : MenuButton
var item_menu : MenuButton

func _enter_tree():
    item_db = ResourceLoader.load("res://questie/item-db.tres")
    if not item_db:
        print("[Questie]: Can't load item database for RewardBlock_AddItem")
        return

    quantity_box = $HBoxContainer/QuantityBox
    category_menu = $HBoxContainer/CategoryButton
    item_menu = $HBoxContainer/ItemButton

    initialize()

    quantity_box.connect("value_changed", self, "on_quantity_changed")
    category_menu.connect("pressed", self, "on_category_pressed")
    category_menu.get_popup().connect("id_pressed", self, "on_category_selected")
    item_menu.connect("pressed", self, "on_item_pressed")
    item_menu.get_popup().connect("id_pressed", self, "on_item_selected")

func _exit_tree():
    quantity_box.disconnect("value_changed", self, "on_quantity_changed")
    category_menu.disconnect("pressed", self, "on_category_pressed")
    category_menu.get_popup().disconnect("id_pressed", self, "on_category_selected")
    item_menu.disconnect("pressed", self, "on_item_pressed")
    item_menu.get_popup().disconnect("id_pressed", self, "on_item_selected")

func initialize():
    load_category_items_from_database()
    if item_db.categories.size() > 0:
        selected_category_index = 0
        var data = item_db.categories[0]
        selected_category_id = data.id
        category_menu.text = data.name

    load_item_items_from_database(selected_category_id)
    if item_db.items.size() > 0:
        selected_item_index = 0
        var data = item_db.items[0]
        selected_item_id = data.id
        item_menu.text = data.name


func load_category_items_from_database():
    var popup = category_menu.get_popup()
    popup.clear()

    for data in item_db.categories:
        popup.add_item(data.name)

func load_item_items_from_database(category_id):
    var popup = item_menu.get_popup()
    popup.clear()

    var fixed_index = -1
    for data in item_db.items:
        fixed_index += 1
        if not data.folder_id == category_id: continue

        popup.add_item(data.name, fixed_index)

func on_quantity_changed(quantity):
    current_quantity = quantity
    emit_signal("quantity_changed", quantity)

func on_category_pressed():
    load_category_items_from_database()

func on_category_selected(index : int):
    var data = item_db.categories[index]
    selected_category_index = index
    selected_category_id = data.id
    category_menu.text = data.name
    emit_signal("category_selected", index, selected_category_id)

func on_item_pressed():
    load_item_items_from_database(selected_category_id)

func on_item_selected(index : int):
    var data = item_db.items[index]
    selected_item_index = index
    selected_item_id = data.id
    item_menu.text = data.name
    emit_signal("item_selected", index, selected_item_id)
