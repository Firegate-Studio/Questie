tool
extends Control
class_name LocationCategoryArea

var new_category_button : Button
var category_tree : Location_CategoryTree

func _enter_tree():

	new_category_button = $"HBoxContainer/New Category Button"
	new_category_button.connect("button_down", self, "on_new_category_requested")

	category_tree = $"ScrollContainer/Tree"

func on_new_category_requested(): 
	category_tree.create_category("New Category")
