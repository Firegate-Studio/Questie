# Represents a database for all in-game objects

tool
extends Resource
class_name ItemDatabase, "res://addons/questie/editor/icons/database.png"

# A category is the item folder
export var categories = []

# The tag is for user only purposes
export var tags = []

# the item data itself
export var items = []

func push_category(category):
	categories.push_back(category)

func push_tag(tag):
	tags.push_back(tag)

func push_item(item):
	items.push_back(item)

func erase_category(id):
	for item in categories:
		if not item.id == id: continue
		categories.erase(item)

func erase_tag(id):
	for item in tags:
		if not item.id == id: continue
		tags.erase(item) 

func erase_item(id):
	for item in items:
		if not item.id == id: continue
		items.erase(item)

func get_category(id):
	for category in categories:
		if not category.id == id : continue

		return category

	return null

func get_tag(id):
	for tag in tags:
		if not tag.id == id: continue

		return tag

	return null

func get_item(id):
	for item in items:
		if not item.id == id: continue

		return item

	return null

func get_category_index(id):
	var index = -1
	for category in categories:
		index += 1
		if not category.id == id: continue

		return index

	return -1

func get_tag_index(id):
	var index = -1
	for tag in tags:
		index += 1
		if not tag.id == id: continue

		return index

	return -1

func get_item_index(id):
	var index = -1
	for item in items:
		index += 1
		if not item.id == id: continue
		
		return index

	return -1
