tool
extends Control

var title : LineEdit
var description : TextEdit
var icon_path : LineEdit
var icon_preview : TextureRect
var can_be_sold : CheckButton
var purchase_price : SpinBox
var sell_price : SpinBox
var value : SpinBox

func _enter_tree():
	
	# Get references from interface
	title = $VBoxContainer/HBoxContainer2/Title
	description = $VBoxContainer/HBoxContainer3/Description
	icon_path = $"VBoxContainer/HBoxContainer4/Icon Path"
	icon_preview = $VBoxContainer/HBoxContainer4/Panel/Icon
	can_be_sold = $VBoxContainer/HBoxContainer5/Sellable
	purchase_price = $"VBoxContainer/HBoxContainer5/Purchase Price"
	sell_price = $"VBoxContainer/HBoxContainer5/Sell Price"
	value = $VBoxContainer/HBoxContainer7/Value
