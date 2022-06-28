tool
extends Control

var title : LineEdit
var description : TextEdit
var icon : LineEdit
var weight : SpinBox
var min_damage : SpinBox
var max_damage : SpinBox
var damage_type : MenuButton
var can_be_sold : CheckButton
var purchase_price : SpinBox
var sell_price : SpinBox

func _enter_tree():

	# Get references from interface
	title = $VBoxContainer/HBoxContainer/Title
	description = get_node("VBoxContainer/VBoxContainer/Description")
	icon = get_node("VBoxContainer/HBoxContainer4/icon")
	weight = get_node("VBoxContainer/HBoxContainer5/Weight")
	min_damage = get_node("VBoxContainer/VBoxContainer2/HBoxContainer/Min Damage")
	max_damage = $"VBoxContainer/VBoxContainer2/HBoxContainer/Max Damage"
	damage_type = $"VBoxContainer/VBoxContainer2/HBoxContainer2/Damage Type"
	can_be_sold = $"VBoxContainer/HBoxContainer2/CheckButton"
	purchase_price = $"VBoxContainer/HBoxContainer3/Purchase Price"
	sell_price = $"VBoxContainer/HBoxContainer3/Sell Price"

func _ready():

	 # Get damage popup
	var popup = damage_type.get_popup()

	# Generate damage type
	popup.set_item_text(0, "Physical")
	popup.set_item_text(1, "Fire")
	popup.set_item_text(2, "Water")
	popup.set_item_text(3, "Nature")
	popup.set_item_text(4, "Air")
	popup.set_item_text(5, "Light")
	popup.set_item_text(6, "Darkness")
	popup.set_item_text(7, "Spirit")

