tool
extends Control

var title = LineEdit
var description = LineEdit
var icon_path : LineEdit
var icon_preview : TextureRect
var armor : SpinBox
var armor_type : MenuButton
var can_be_sold : CheckButton
var purchase_price : SpinBox
var sell_price : SpinBox

func _enter_tree():

	# Get references from interface
	title = $VBoxContainer/HBoxContainer/Title
	description = $VBoxContainer/VBoxContainer/Description
	icon_path = $"VBoxContainer/HBoxContainer3/Icon path"
	icon_preview = $VBoxContainer/HBoxContainer3/Panel/Icon
	armor = $VBoxContainer/HBoxContainer2/Armor
	armor_type = $VBoxContainer/HBoxContainer2/Type
	can_be_sold = $"VBoxContainer/HBoxContainer4/Can Be Sold"
	purchase_price = $"VBoxContainer/HBoxContainer4/Purchase Price"
	sell_price = $"VBoxContainer/HBoxContainer4/Sell Price"

func _ready():
	
	# Get type popup
	var popup = armor_type.get_popup()

	# Create armor type items
	popup.add_item("Physic")
	popup.add_item("Magic")
