tool
extends Control
class_name LocationEditor

var category_area : LocationCategoryArea
var workspace : LocationViewport

var current_selected_category : TreeItem

var location_database

func _enter_tree(): 
	location_database = load("res://questie/location-db.tres")

	category_area = $"HSplitContainer/category_area"
	workspace = $"HSplitContainer/Location Viewport"

	workspace.hide()

func _ready():
	category_area.category_tree.connect("category_selected", self, "on_category_selected")
	category_area.category_tree.connect("category_deletion", self, "on_category_deletion")
	workspace.connect("new_location", self, "on_new_location_request")

func on_category_selected(category):

	workspace.clear()
	load_category_locations(category)
	
	current_selected_category = category
	workspace.show()

func on_category_deletion(id):

	var stored_locations = []
	# erase location from database
	for location_data in location_database.locations:
		if not location_data.category_id == id: 
			stored_locations.push_back(location_data)
			continue
	
		# destroy location slots
		for child in workspace.location_slots_container.get_children():
			if not child.id == location_data.id: continue
					
	location_database.locations = stored_locations

	ResourceSaver.save("res://questie/location-db.tres", location_database)

	workspace.hide()

func on_new_location_request():
	add_location(UUID.generate(), current_selected_category)

func on_location_name_changed(id, text): 
	for location_data in location_database.locations:
		if not location_data.id == id: continue

		location_data.name = text
		ResourceSaver.save("res://questie/location-db.tres", location_database)

		print("[Questie]: changed location name to " + text)
		break

func on_location_note_changed(id, text):
	for location_data in location_database.locations:
		if not location_data.id == id: continue

		location_data.note = text
		ResourceSaver.save("res://questie/location-db.tres", location_database)

		print("[Questie]: changed location note to " + text)
		break

func on_location_delete(id, slot): 
	
	location_database.remove_location(id)
	ResourceSaver.save("res://questie/location-db.tres", location_database)

	slot.disconnect("name_changed", self, "on_location_name_changed")
	slot.disconnect("note_changed", self, "on_location_note_changed")
	slot.disconnect("delete", self, "on_location_delete")

	slot.queue_free()


func add_location(location_id, category_item):

	var location_slot = load("res://addons/questie/editor/location_editor/location_slot.tscn").instance()
	location_slot.id = location_id

	# subscribe events
	location_slot.connect("name_changed", self, "on_location_name_changed")
	location_slot.connect("note_changed", self, "on_location_note_changed")
	location_slot.connect("delete", self, "on_location_delete", [location_slot])

	# generate data
	var location_data = LocationData.new()
	location_data.id = location_id
	location_data.category_id = category_area.category_tree.categories[current_selected_category]

	# bind data to database
	location_database.add_location(location_data)
	ResourceSaver.save("res://questie/location-db.tres", location_database)

	# show location slot in workspace
	workspace.location_slots_container.add_child(location_slot)

func load_location_slot(location_data):
	var location_slot = load("res://addons/questie/editor/location_editor/location_slot.tscn").instance()
	# show location slot in workspace
	workspace.location_slots_container.add_child(location_slot)

	# seutp slot values
	location_slot.id = location_data.id
	location_slot.location_name.text = location_data.name
	location_slot.location_note.text = location_data.note

	# subscribe events
	location_slot.connect("name_changed", self, "on_location_name_changed")
	location_slot.connect("note_changed", self, "on_location_note_changed")
	location_slot.connect("delete", self, "on_location_delete", [location_slot])



func load_category_locations(category):
	if not category:
		print("[Questie]: selected category is not valid!")
		return

	var category_id = category_area.category_tree.categories[category]

	for location_data in location_database.locations:
		if not location_data.category_id == category_id: continue

		load_location_slot(location_data)


	

