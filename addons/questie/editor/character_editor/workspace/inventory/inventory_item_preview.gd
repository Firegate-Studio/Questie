# the item slot to preview inside the selection popup
tool
extends Button

# called when this item is pressed
signal selected(id)

var _name : Label
var _icon : TextureRect

# the identifier of the item of the database represented by this slot
var _id : String

func _enter_tree():

	_name = $VBoxContainer/name
	_icon = $VBoxContainer/TextureRect

	connect("button_down", self, "on_item_clicked")

func _exit_tree():
	disconnect("button_down", self, "on_item_clicked")

func on_item_clicked():
	emit_signal("selected", _id)

