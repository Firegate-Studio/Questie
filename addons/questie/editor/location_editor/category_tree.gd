tool
extends Tree
class_name Location_CategoryTree

var root : TreeItem

var location_database = preload("res://questie/location-db.tres")

var categories = []

func _enter_tree():

	root = create_item(null)
	root.set_text(0, "Categories")
	
	set_hide_root(true)

	connect("item_edited", self, "on_category_edited")
	connect("item_double_clicked", self, "on_category_double_clicked")
	connect("button_pressed", self, "on_category_button_pressed")
	
	# load categories
	for key in location_database.data:
		create_category(key)


func on_category_edited(): 
	var selected_category = get_selected()
	if not selected_category:
		print("[Questie]: can not detect selected category")
		return

	location_database.add_category(selected_category.get_text(0))
	location_database.clenup_categories(get_all_categories_name())
	ResourceSaver.save("res://questie/location-db.tres", location_database)

func on_category_double_clicked():
	var category = get_selected()
	if not category:
		print("[Questie]: category item is invalid for modification")
		return
	
	category.set_editable(0, true)

func on_category_button_pressed(item, column, id): 
	print("category deletion requested for category: " + item.get_text(0))

	root.remove_child(item)

	location_database.remove_category(item.get_text(0))
	ResourceSaver.save("res://questie/location-db.tres", location_database)

# Create a new category
func create_category(title):
	var category_item : TreeItem = create_item(root)
	category_item.set_text(0, title)
	category_item.set_editable(0, true)
	category_item.set_expand_right(0, true)
	category_item.set_icon(0, load("res://addons/questie/editor/icons/village.png"))
	category_item.set_icon_max_width(0, 32)
	category_item.set_custom_as_button(0, true)

	var icon : Texture = load("res://addons/questie/editor/icons/trash_32x32.png")
	category_item.add_button(0, icon)

	categories.push_back(category_item)

	location_database.add_category(category_item.get_text(0))
	ResourceSaver.save("res://questie/location-db.tres", location_database)

func get_all_categories_name()->Array:

	var result = []
	
	for category in categories:
		result.push_back(category.get_text(0))

	return result
