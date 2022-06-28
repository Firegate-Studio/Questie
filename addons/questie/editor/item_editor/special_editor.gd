tool
extends Control

var title : LineEdit
var description : TextEdit
var icon_path : LineEdit
var icon_preview : TextureRect
var weight : SpinBox
var can_be_sold : CheckButton
var purchase_price : SpinBox
var sell_price : SpinBox
var as_weapon : CheckButton
var damage_type : MenuButton
var min_damage : SpinBox
var max_damage : SpinBox
var as_armor : CheckButton
var armor_type : MenuButton
var armor_value : SpinBox
var as_consumable : CheckButton
var consumable_value : SpinBox
var is_unique : CheckButton

func _enter_tree():

	# Get references from interface
	title = $ScrollContainer/VBoxContainer/HBoxContainer2/Title
	description = $ScrollContainer/VBoxContainer/HBoxContainer3/Description
	icon_path = $"ScrollContainer/VBoxContainer/HBoxContainer4/Icon Path"
	icon_preview = $ScrollContainer/VBoxContainer/HBoxContainer4/Panel/Icon
	weight = $ScrollContainer/VBoxContainer/HBoxContainer13/Weight
	can_be_sold = $ScrollContainer/VBoxContainer/HBoxContainer5/Sellable
	purchase_price = $"ScrollContainer/VBoxContainer/HBoxContainer5/Purchase Price"
	sell_price = $"ScrollContainer/VBoxContainer/HBoxContainer5/Sell price"
	
	as_weapon = $"ScrollContainer/VBoxContainer/HBoxContainer7/As Weapon"
	damage_type = $"ScrollContainer/VBoxContainer/HBoxContainer7/Weapon type"
	min_damage = $"ScrollContainer/VBoxContainer/HBoxContainer7/min damage"
	max_damage = $"ScrollContainer/VBoxContainer/HBoxContainer7/max damage"
	
	as_armor = $"ScrollContainer/VBoxContainer/HBoxContainer9/As armor"
	armor_type = $"ScrollContainer/VBoxContainer/HBoxContainer9/Armor Type"
	armor_value = $"ScrollContainer/VBoxContainer/HBoxContainer9/Armor Value"

	as_consumable = $"ScrollContainer/VBoxContainer/HBoxContainer11/As Consumable"
	consumable_value = $"ScrollContainer/VBoxContainer/HBoxContainer11/Consumable Value"

	is_unique = $"ScrollContainer/VBoxContainer/Is Unique"

	# Load Damage Type popup
	var dmg = damage_type.get_popup()
	dmg.clear()
	dmg.add_item("Physic")
	dmg.add_item("Fire")
	dmg.add_item("Water")
	dmg.add_item("Nature")
	dmg.add_item("Air")
	dmg.add_item("Light")
	dmg.add_item("Darkness")
	dmg.add_item("Spirit")

	# Load armor type popup
	var arm = armor_type.get_popup()
	arm.clear()
	arm.add_item("Physic")
	arm.add_item("Magic")
