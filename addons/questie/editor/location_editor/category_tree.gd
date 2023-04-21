tool
extends Tree
class_name Location_CategoryTree

signal category_selected(item)
signal category_renamed(item, new_name)
signal category_deletion(id)

var root : TreeItem

var location_database = preload("res://questie/location-db.tres")

var categories = {}

func _enter_tree():
	root = create_item()
	
	connect("item_selected", self, "on_item_selected")
	connect("item_edited", self, "on_item_edited")
	connect("button_pressed", self, "on_button_pressed")

	for category in location_database.categories:
		print("[Questie]: loading " + category.title)
		load_category(null, category.title, category.id)
	print("[Quesite]: all categories loaded")

func on_item_selected():
	emit_signal("category_selected", get_selected())

func on_item_edited():
	var selected_category = get_selected()
	if not selected_category:
		print("[Questie]: the selected category is not valid")
		return

	if not categories.has(selected_category):
		print("[Questie]: can't edit the current category cause is not exists anymore")
		return

	var category_id = categories[selected_category]
	for category in location_database.categories:
		if not category.id == category_id: continue

		category.title = selected_category.get_text(0)
		print("[Questie]: category title changed to " + selected_category.get_text(0) + " for category with identifier: " + category_id)
		ResourceSaver.save("res://questie/location-db.tres", location_database)

		emit_signal("category_renamed", selected_category, selected_category.get_text(0))

		break

func on_button_pressed(item, column, id):
	
	var location_id : String

	# search item from database
	for tree_item in categories:
		if not tree_item == item: continue

		location_id = categories[tree_item]
		categories.erase(tree_item)
		break

	item.get_parent().remove_child(item)
	location_database.remove_category(location_id)
	emit_signal("category_deletion", location_id)

	ResourceSaver.save("res://questie/location-db.tres", location_database)

func create_category(parent, title, id):

	# generate category
	var category_item = create_item(parent)
	category_item.set_text(0, title)
	category_item.set_editable(0, true)
	category_item.set_expand_right(0, true)
	category_item.set_custom_as_button(0, true)
	category_item.set_icon(0, load("res://addons/questie/editor/icons/village.png"))
	category_item.set_icon_max_width(0, 32)
	category_item.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))

	# generate identifier
	categories[category_item] = id
	
	# generate category data
	var data = LocationCategoryData.new()
	data.id = id
	data.title = title

	# save category
	location_database.add_category(data)
	ResourceSaver.save("res://questie/location-db.tres", location_database)

func load_category(parent, title, id):

	print("[Questie]: loading " + title)

	# generate category
	var category_item = create_item(root)
	category_item.set_text(0, title)
	category_item.set_editable(0, true)
	category_item.set_expand_right(0, true)
	category_item.set_custom_as_button(0, true)
	category_item.set_icon(0, load("res://addons/questie/editor/icons/village.png"))
	category_item.set_icon_max_width(0, 32)
	category_item.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))

	# generate identifier
	categories[category_item] = id
