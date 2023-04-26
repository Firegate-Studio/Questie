tool
extends Panel

signal category_selected(category_id, category_index)
signal location_selected(location_id, location_index)
signal deletion_request(node)

var location_menu : MenuButton
var category_menu : MenuButton
var delete_button : Button

var category_id : String
var location_id : String

var category_index : int
var location_index : int

var location_database = preload("res://questie/location-db.tres")

func _enter_tree():

	location_menu = $"HBoxContainer/location menu"
	category_menu = $"HBoxContainer/category menu"
	delete_button = $HBoxContainer/delete

	category_menu.get_popup().connect("id_pressed", self, "on_category_item_selected")
	location_menu.get_popup().connect("id_pressed", self, "on_location_item_selected")
	delete_button.connect("button_down", self, "on_deletion_requested")

	load_categories_from_database()

func on_category_item_selected(id):

	category_menu.text = category_menu.get_popup().get_item_text(id)
	location_menu.text = "location"

	category_id = location_database.categories[id].id
	category_index = id
	emit_signal("category_selected", category_id, category_index)

	load_locations_from_database(category_id)

func on_location_item_selected(id):

	location_menu.text = location_menu.get_popup().get_item_text(id)

	location_id = location_database.locations[0].id
	location_index = id
	emit_signal("location_selected", location_id, location_index)

func on_deletion_requested():
	emit_signal("deletion_request", self)

func load_categories_from_database():

	var popup = category_menu.get_popup()
	popup.clear()

	for category in location_database.categories:
		popup.add_item(category.title)

func load_locations_from_database(category_id):
	
	var popup = location_menu.get_popup()
	popup.clear()

	for location in location_database.locations:
		if not location.category_id == category_id: continue

		popup.add_item(location.name)




