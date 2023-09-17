tool
extends GraphNode
class_name TriggerBlock_CharacterExitLocation

signal character_selected(character_index, character_id)
signal region_selected(region_index, region_id)
signal location_selected(location_index, location_id)

var characters_database : CharacterDatabase
var location_database : LocationDatabase

var character_menu : OptionButton
var region_menu : MenuButton
var region_name : Label
var location_menu : MenuButton
var location_name : Label

var selected_region_index : int = -1
var selected_region_id : String = ""

var selected_location_index : int = -1
var selected_location_id : String = ""

var selected_character_index : int = -1
var selected_character_id : String = ""

func _enter_tree():
	location_database = ResourceLoader.load("res://questie/location-db.tres")
	characters_database = ResourceLoader.load("res://questie/characters-db.tres")

	if not location_database or not characters_database:
		print("[Questie]: can not load location or character database!")
		return

	character_menu = $"HBoxContainer/Character Button"
	region_menu = $"HBoxContainer/VBoxContainer/Region Button"
	region_name = $"HBoxContainer/VBoxContainer/Region Name"
	location_menu = $"HBoxContainer/VBoxContainer2/Location Button"
	location_name = $"HBoxContainer/VBoxContainer2/Location Name"

	initialize()

	character_menu.connect("pressed", self, "on_character_menu_pressed")
	character_menu.get_popup().connect("id_pressed", self, "on_character_menu_item_selected")
	region_menu.connect("pressed", self, "on_region_menu_pressed")
	region_menu.get_popup().connect("id_pressed", self, 'on_region_menu_item_selected')
	location_menu.connect("pressed", self, "on_location_menu_pressed")
	location_menu.get_popup().connect("id_pressed", self, "on_location_menu_item_selected")

func initialize():
	
	# setup current selected character
	if characters_database.characters.size() > 0:
		load_character_items_from_database()
		selected_character_index = 0
		character_menu.text = characters_database.characters[0].title
		selected_character_id = characters_database.characters[0].id
	else:
		character_menu.text = "Compile some characters first"
		
	# setup selected region
	if location_database.categories.size() > 0:
		load_region_items_from_database()
		selected_region_index = 0
		selected_region_id = location_database.categories[0].id
		region_name.text = location_database.categories[0].title
	else:
		region_name.text = "create a region first"

	# setup selected location
	if location_database.locations.size() > 0:
		load_location_item_by_region(selected_region_id, selected_region_index)
		selected_location_index = 0
		selected_location_id = location_database.locations[0].id
		location_name.text = location_database.locations[0].name

func load_character_items_from_database(): 
	var popup = character_menu.get_popup()
	popup.clear()

	for character_data in characters_database.characters:
		popup.add_item(character_data.title)

func load_region_items_from_database():
	var popup = region_menu.get_popup()
	popup.clear()

	for region_data in location_database.categories:
		popup.add_item(region_data.title)

func load_location_item_by_region(region_id : String, region_index : int):
	if region_index == -1: return
	
	var popup = location_menu.get_popup()
	popup.clear()

	for location_data in location_database.locations:
		if not location_data.category_id == region_id: continue

		popup.add_item(location_data.name)

func on_character_menu_pressed():
	load_character_items_from_database()

func on_character_menu_item_selected(item_index : int):
	selected_character_index = item_index 
	selected_character_id = characters_database.characters[item_index].id
	character_menu.text = characters_database.characters[item_index].name
	emit_signal("character_selected", selected_character_index, selected_character_id)

func on_region_menu_pressed():
	if location_database.categories.size() == 0: return 
	
	load_region_items_from_database()
	
func on_region_menu_item_selected(region_index : int):
	selected_region_index = region_index
	selected_region_id = location_database.categories[region_index].id
	region_name.text = location_database.categories[region_index].title
	emit_signal("region_selected", selected_region_index, selected_region_id)

func on_location_menu_pressed():
	if location_database.locations.size() == 0: return
	if selected_region_index < 0: return 
	
	load_location_item_by_region(selected_region_id, selected_region_index)

func on_location_menu_item_selected(location_index : int):
	selected_location_index = location_index 
	selected_location_id = location_database.locations[location_index].id
	location_name.text = location_database.locations[location_index].name
	emit_signal("location_selected", selected_location_index, selected_location_id)
