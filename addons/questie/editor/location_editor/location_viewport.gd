tool
extends VBoxContainer
class_name LocationViewport

signal new_location()
signal delete_location(id, name, note, node)

var new_location_button : Button
var location_slots_container = VBoxContainer

var location_database

func _enter_tree(): 

	location_database = load("res://questie/location-db.tres")

	new_location_button = $"HBoxContainer/New Location Button"
	location_slots_container = $"ScrollContainer/VBoxContainer"

	new_location_button.connect("button_down", self, "on_new_location_button_clicked")

func on_new_location_button_clicked(): 
	print("[Questie]: new location requested")
	emit_signal("new_location")

func on_location_delete(id, name, note, node): 
	emit_signal("delete_location", [id, name, note, node])

func clear():
	for item in location_slots_container.get_children():
		item.queue_free()


	
