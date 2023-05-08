tool 
extends Button

signal slot_deletion_requested(item_id)

var _item_name : Label
var _icon : TextureRect
var _quantity : SpinBox
var _delete_btn : Button

# the identifer of the character owning this item
var character_id : String

# the id of the item represented by this slot
var item_id : String

func _enter_tree():
	_item_name = $HBoxContainer/VBoxContainer/Label
	_icon = $"HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Icon"
	_quantity = $HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Quantity
	_delete_btn = $HBoxContainer/VBoxContainer/HBoxContainer/Button

	_delete_btn.connect("button_down", self, "on_delete_button_clicked")

func on_delete_button_clicked():
	queue_free()
	emit_signal("slot_deletion_requested", item_id)
