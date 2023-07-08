tool
extends Panel

signal location_selected(location_id, location_index)
signal category_selected(category_id)
signal deletion_request(node)

var location_menu : MenuButton
var category_menu : MenuButton
var delete_button : Button
var location_database = preload("res://questie/location-db.tres")

var location_id : String
var location_index : int
var category_index : int

func _enter_tree():
	location_menu = $"HBoxContainer/location menu"
	category_menu = $"HBoxContainer/category menu"
	delete_button = $"HBoxContainer/delete button"

	# subscribe events
	location_menu.get_popup().connect("id_pressed", self, "on_location_item_selected")
	category_menu.get_popup().connect("id_pressed", self, "on_category_item_selected")
	delete_button.connect("button_down", self, "on_delete_button_pressed")

	load_category_items_from_database()
	load_location_items_from_database()

func _exit_tree():
	location_menu.get_popup().disconnect("id_pressed", self, "on_location_item_selected")
	category_menu.get_popup().disconnect("id_pressed", self, "on_category_item_selected")
	delete_button.disconnect("button_down", self, "on_delete_button_pressed")

func on_location_item_selected(id):
	var popup = location_menu.get_popup()
	var data = location_database.locations[id]

	location_menu.text = data.name

	location_id = data.id
	location_index = id
	emit_signal("location_selected", location_id, location_index)

func on_category_item_selected(id):
	var popup = category_menu.get_popup()
	var data = location_database.categories[id]

	category_menu.text = data.title
	category_index = id
	emit_signal("category_selected", id)

func on_delete_button_pressed():
	emit_signal("deletion_request", self)

func load_location_items_from_database():
	var popup = location_menu.get_popup()
	popup.clear()

	for location in location_database.locations:
		popup.add_item(location.name)

func load_category_items_from_database():
	var popup = category_menu.get_popup()
	popup.clear()

	for category in location_database.categories:
		popup.add_item(category.title)

func autoload(loc_id, loc_index, cat_index):
	
	if loc_index > -1:
		var data = location_database.locations[loc_index]
		location_menu.text = data.name
		location_id = loc_id
		location_index = loc_index

	if cat_index > -1:
		var data = location_database.categories[cat_index]
		category_menu.text = data.title
		category_index = cat_index


