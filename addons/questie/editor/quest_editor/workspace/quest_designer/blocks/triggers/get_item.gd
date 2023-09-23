tool
extends GraphNode
class_name TriggerBlock_GetItem

signal category_selected(category_index, category_id)
signal item_selected(item_index, item_id)

var item_db : ItemDatabase

var category_menu : MenuButton
var item_menu : MenuButton

var selected_item_category_index : int = -1
var selected_item_category_id : String = ""

var selected_item_index : int = -1;
var selected_item_id : String = ""

func _enter_tree():
	item_db = ResourceLoader.load("res://questie/item-db.tres")
	if not item_db:
		print("[Questie]: Cannot load item database!")
		return

	category_menu = $"HBoxContainer/Category Menu"
	item_menu = $"HBoxContainer/Item Menu"

	initialize()

	category_menu.connect("pressed", self, "on_category_menu_pressed")
	category_menu.get_popup().connect("id_pressed", self, "on_category_item_selected")
	item_menu.connect("pressed", self, "on_item_menu_pressed")
	item_menu.get_popup().connect("id_pressed", self, "on_item_id_pressed")

func initialize():
	if item_db.categories.size() > 0: 
		load_category_items_from_database()
		selected_item_category_index = 0
		selected_item_category_id = item_db.categories[0].id
		category_menu.text = item_db.categories[0].name
	else:
		category_menu.text = "create an item category first!"

	if item_db.items.size() > 0:
		load_object_items_from_database_by_category(selected_item_category_index, selected_item_category_id)
		selected_item_index = 0
		selected_item_id = item_db.items[0].id
		item_menu.text = item_db.items[0].name
	else:
		item_menu.text = "creat an item first!"


func load_category_items_from_database():
	var popup = category_menu.get_popup()
	popup.clear()

	for data in item_db.categories:
		popup.add_item(data.name)

func load_object_items_from_database_by_category(category_index : int, category_id : String):
	var popup = item_menu.get_popup()
	popup.clear()

	var fixed_index = -1
	for data in item_db.items:
		fixed_index += 1
		#print("category id: " + category_id + " | folder_id: " + data.folder_id + " | tag id: " + data.tag_id)
		if not data.folder_id == category_id and not data.tag_id == category_id: continue

		popup.add_item(data.name, fixed_index)

func on_category_menu_pressed():
	if item_db.categories.size() == 0: return
	load_category_items_from_database()

func on_category_item_selected(category_index):
	selected_item_category_index = category_index
	selected_item_category_id = item_db.categories[category_index].id
	category_menu.text = item_db.categories[category_index].name
	emit_signal("category_selected", selected_item_category_index, selected_item_category_id)

func on_item_menu_pressed():
	if selected_item_category_index == -1: 
		print("[Questie]: items database is empty!")
		return

	load_object_items_from_database_by_category(selected_item_category_index, selected_item_category_id)


func on_item_id_pressed(item_index : int):
	selected_item_index = item_index
	selected_item_id = item_db.items[item_index].id
	item_menu.text = item_db.items[item_index].name
	emit_signal("item_selected", selected_item_index, selected_item_id)
