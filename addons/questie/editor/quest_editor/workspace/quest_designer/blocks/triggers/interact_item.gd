tool
extends GraphNode
class_name TriggerBlock_InteractItem

signal item_selected(item_index, item_id)
signal category_selected(category_index, category_id)

var selected_category_index : int = -1
var selected_category_id : String = ""

var selected_item_index : int = -1
var selected_item_id : String = "" 

var category_menu : MenuButton
var item_menu : MenuButton

var item_database : ItemDatabase = null

func _enter_tree():
	item_database = ResourceLoader.load("res://questie/item-db.tres")

	category_menu = $"HBoxContainer/Category Menu"
	item_menu = $"HBoxContainer/Item Menu"

	load_category_items_from_database()
	if item_database.categories.size() > 0:
		selected_category_index = 0
		selected_category_id = item_database.categories[0].id
		category_menu.text = item_database.categories[0].name

	load_item_items_from_database(selected_category_id)
	if item_database.items.size() > 0:
		selected_item_index = 0
		selected_item_id = item_database.items[0].id
		item_menu.text = item_database.items[0].name

	category_menu.connect("pressed", self, "on_category_menu_pressed")
	category_menu.get_popup().connect("id_pressed", self, "on_category_selected")

	item_menu.connect("pressed", self, "on_item_menu_pressed")
	item_menu.get_popup().connect("id_pressed", self, "on_item_selected")
	

func load_category_items_from_database():
	var popup = category_menu.get_popup()
	popup.clear()

	for category_data in item_database.categories:
		popup.add_item(category_data.name)

func load_item_items_from_database(category_id : String):
	var popup = item_menu.get_popup()
	popup.clear()

	var fixed_index = -1
	for item_data in item_database.items:
		fixed_index += 1

		var tag_data = item_database.get_tag(item_data.tag_id)
		if tag_data:
		#if not item_data.folder_id == category_id and not tag_data.folder_id == category_id: continue
			if not tag_data.folder_id == category_id: continue
		else:
			if not item_data.folder_id == category_id: continue
		
		popup.add_item(item_data.name, fixed_index)

func on_category_menu_pressed():
	load_category_items_from_database()

func on_category_selected(index : int):
	selected_category_index = index
	selected_category_id = item_database.categories[index].id
	category_menu.text = item_database.categories[index].name
	emit_signal("category_selected", index, selected_category_id)

func on_item_menu_pressed():
	load_item_items_from_database(selected_category_id) 

func on_item_selected(index : int):
	selected_item_index = index
	selected_item_id = item_database.items[index].id
	item_menu.text = item_database.items[index].name
	emit_signal("item_selected", index, selected_item_id)
		
