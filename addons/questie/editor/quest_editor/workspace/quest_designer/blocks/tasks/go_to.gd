tool
extends GraphNode
class_name TaskBlock_GoTo

signal region_selected(region_index, region_id)
signal location_selected(location_index, location_id)

var location_database : LocationDatabase = null

var region_menu : MenuButton
var location_menu : MenuButton

var selected_region_index : int = -1
var selected_region_id : String

var selected_location_index : int = -1
var selected_location_id : String

func _enter_tree():
	location_database = ResourceLoader.load("res://questie/location-db.tres")
	if not location_database:
		print("[Questie]: can not load location database for TaskBlock_GoTo")
		return

	region_menu = $HBoxContainer/CategoryMenu
	location_menu = $HBoxContainer/ItemMenu

	initialize()

	region_menu.connect("pressed", self, "on_region_menu_pressed")
	region_menu.get_popup().connect("id_pressed", self, "on_region_selected")

	location_menu.connect("pressed", self, "on_location_menu_pressed")
	location_menu.get_popup().connect("id_pressed", self, "on_location_selected")

func _exit_tree():
	region_menu.disconnect("pressed", self, "on_region_menu_pressed")
	region_menu.get_popup().disconnect("id_pressed", self, "on_region_selected")

	location_menu.disconnect("pressed", self, "on_location_menu_pressed")
	location_menu.get_popup().disconnect("id_pressed", self, "on_location_selected")

func initialize():
	load_region_items_from_database()
	if location_database.categories.size() > 0:
		selected_region_index = 0
		selected_region_id = location_database.categories[0].id
		region_menu.text = location_database.categories[0].title

	load_location_items_from_database(selected_region_id)
	if location_database.locations.size() > 0:
		selected_location_index = 0
		selected_location_id = location_database.locations[0].id
		location_menu.text = location_database.locations[0].name

func load_region_items_from_database():
	var popup = region_menu.get_popup()
	popup.clear()

	for data in location_database.categories:
		popup.add_item(data.title)

func load_location_items_from_database(category_id : String):
	var popup = location_menu.get_popup()
	popup.clear()

	var fixed_index = -1
	for data in location_database.locations:
		fixed_index += 1
		if not data.category_id == category_id: continue

		popup.add_item(data.name, fixed_index) 

func on_region_menu_pressed():
	load_region_items_from_database()

func on_region_selected(index : int):
	selected_region_index = index
	selected_region_id = location_database.categories[index].id
	region_menu.text = location_database.categories[index].title
	emit_signal("region_selected", index, selected_region_id)

func on_location_menu_pressed():
	load_location_items_from_database(selected_region_id)

func on_location_selected(index : int):
	selected_location_index = index
	selected_location_id = location_database.locations[index].id
	location_menu.text = location_database.locations[index].name
	emit_signal("location_selected", index, selected_location_id)

