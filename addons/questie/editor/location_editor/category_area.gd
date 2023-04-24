tool
extends Control
class_name LocationCategoryArea

var new_category_button : Button
var compile_button : Button
var category_tree : Location_CategoryTree

var location_database

func _enter_tree():
	location_database = load("res://questie/location-db.tres")
	
	new_category_button = $"HBoxContainer/New Category Button"
	compile_button = $"HBoxContainer/Compile Button"
	category_tree = $"ScrollContainer/Tree"

	new_category_button.connect("button_down", self, "on_new_category_button_clicked")
	compile_button.connect("button_down", self, "on_compile_button_clicked")

func on_new_category_button_clicked():
	category_tree.create_category(null, "new category", UUID.generate())

func on_compile_button_clicked():
	LocationFileBuilder.build()



