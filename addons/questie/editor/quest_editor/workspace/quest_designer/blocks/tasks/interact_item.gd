tool
extends GraphNode
class_name TaskBlock_InteractItem

signal category_selected(category_index, category_id)
signal item_selected(item_index, item_id)

var item_database : ItemDatabase  = null

var category_menu : MenuButton
var item_menu : MenuButton

var selected_category_index : int = -1
var selected_category_id : String

var selected_item_index : int = -1
var selected_item_id : String

func _enter_tree():
	item_database = ResourceLoader.load("res://questie/item-db.tres")
	if not item_database:
		print("[Questie]: Can's load item database for TaskBlock_InteractItem")
		return

	category_menu = $HBoxContainer/CategoryMenu
	item_menu = $HBoxContainer/ItemMenu

	initialize()

	category_menu.connect("pressed", self, "on_category_menu_pressed")
	category_menu.get_popup().connect("id_pressed", self, "on_category_selected")

	item_menu.connect("pressed", self, "on_item_menu_pressed")
	item_menu.get_popup().connect("id_pressed", self, "on_item_selected")

func _exit_tree():
	category_menu.disconnect("pressed", self, "on_category_menu_pressed")
	category_menu.get_popup().disconnect("id_pressed", self, "on_category_selected")

	item_menu.disconnect("pressed", self, "on_item_menu_pressed")
	item_menu.get_popup().disconnect("id_pressed", self, "on_item_selected")

func initialize():
	load_category_items()
	if item_database.categories.size() > 0:
		selected_category_index = 0
		selected_category_id = item_database.categories[0].id
		category_menu.text = item_database.categories[0].name

	load_item_items(selected_category_id)
	if item_database.items.size() > 0:
		selected_item_index = 0
		selected_item_id = item_database.items[0].id
		item_menu.text = item_database.items[0].name

func load_category_items():
	var popup = category_menu.get_popup()
	popup.clear()

	for data in item_database.categories:
		popup.add_item(data.name)

func load_item_items(category_id):
	var popup = item_menu.get_popup()
	popup.clear()

	var fixed_index = -1
	for data in item_database.items:
		fixed_index += 1

		var tag_data = item_database.get_tag(data.tag_id)
		if not data.folder_id == category_id and not tag_data.folder_id == category_id: continue

		popup.add_item(data.name, fixed_index)

func on_category_menu_pressed():
	load_category_items()

func on_category_selected(index : int):
	selected_category_index = index
	selected_category_id = item_database.categories[index].id
	category_menu.text = item_database.categories[index].name
	emit_signal("category_selected", index, selected_category_id)

func on_item_menu_pressed():
	load_item_items(selected_category_id)
	
func on_item_selected(index : int):
	selected_item_index = index
	selected_item_id = item_database.items[index].id
	item_menu.text = item_database.items[index].name
	emit_signal("item_selected", index, selected_item_id)
