tool
extends Button

signal quantity_changed(value)
signal deletion_request()

var _name : Label
var _icon : TextureRect
var _value : Label
var _quantity : SpinBox
var _delete_btn : Button

# the item identifier for the item database
var _id : String

func _enter_tree():
	_name = $VBoxContainer/Name
	_icon = $VBoxContainer/HBoxContainer/icon
	_value = $VBoxContainer/HBoxContainer2/value
	_quantity = $VBoxContainer/HBoxContainer2/quantity
	_delete_btn = $"VBoxContainer/HBoxContainer/delete button"

	_quantity.connect("value_changed", self, "on_value_changed")
	_delete_btn.connect("button_down", self, "on_delete_button_clicked")

func on_value_changed(value):
	emit_signal("quantity_changed", value)

func on_delete_button_clicked():
	emit_signal("deletion_request")

	
