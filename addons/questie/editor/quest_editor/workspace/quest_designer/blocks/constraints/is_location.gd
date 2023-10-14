tool
extends GraphNode
class_name ConstraintBlock_IsLocation

var location_databse : LocationDatabase

var location_menu : MenuButton
var current_location_index : int
var current_location_id : String

func _enter_tree():
	location_databse = load("res://questie/location-db.tres")
	if not location_databse:
		print("[Questie]: can't load location database for location constraint block")
		return

	location_menu = $HBoxContainer/LocationMenu

	location_menu.get_popup().connect("id_pressed", self, "on_location_pressed")

	load_location_items()

func _ready():
	set_slot(0, false, 1, get_slot_color_left(0), true, 1, get_slot_color_right(0))

func on_location_pressed(index : int):
	current_location_index = index
	current_location_id = location_databse.locations[index].id

	location_menu.text = location_menu.get_popup().get_item_text(index)


func load_location_items():
	var popup = location_menu.get_popup()
	popup.clear()

	for location in location_databse.locations:
		popup.add_item(location.name)
		
