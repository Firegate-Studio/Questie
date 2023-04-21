tool
extends Panel
class_name LocationSlot

signal delete(id)
signal name_changed(id, text)
signal note_changed(id, text)

# the identifier of the location
var id : String
var location_name : LineEdit
var location_note : LineEdit
var delete_button : Button

func _enter_tree():
	location_name = $"HBoxContainer/VBoxContainer/HBoxContainer/location_name"
	location_note = $"HBoxContainer/VBoxContainer/HBoxContainer2/location_name"
	delete_button = $"HBoxContainer/Delete Button"

	location_name.connect("text_changed", self, "on_name_changed")
	location_note.connect("text_changed", self, "on_note_changed")
	delete_button.connect("button_down", self, "on_location_deletion")

func on_name_changed(text):
	emit_signal("name_changed", id, text)

func on_note_changed(text):
	emit_signal("note_changed", id, text)

func on_location_deletion():
	emit_signal("delete", id)
