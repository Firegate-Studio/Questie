tool
extends Panel

# @brief				called when the user select the item from scene
# @param item_uuid		the uuid of the item selected
# @param category		the category of the item into item database
# @param data			item information stored into item database
signal item_selected(item_uuid, category, data)
signal destruction_requested()

var uuid : LineEdit
var item : MenuButton
var category : MenuButton
var delete : Button

var database = preload("res://questie/item-db.tres")

var category_idx = 1        # the item index for [database.ItemCategory]
var item_idx = -1           # the slot filled from item

# @brief                    Loads popup items by category
# @param type               item category
func load_items_from_database(var type : int):

	var popup = item.get_popup()
	popup.clear()               # Removes all items

	match type:
		database.ItemCategory.WEAPON:
			for context in database.weapons:
				popup.add_item(context.title)
		database.ItemCategory.ARMOR:
			for context in database.armors:
				popup.add_item(context.title)
		database.ItemCategory.CONSUMABLE:
			for context in database.consumables:
				popup.add_item(context.title)
		database.ItemCategory.MATERIAL:
			for context in database.materials:
				popup.add_item(context.title)
		database.ItemCategory.SPECIAL:
			for context in database.specials:
				popup.add_item(context.title)

func load_categories_from_database():

	var popup = category.get_popup()
	popup.clear()
	popup.add_item("Weapons")
	popup.add_item("Armors")
	popup.add_item("Consoumables")
	popup.add_item("Materials")
	popup.add_item("Specials")

	# Remap item indicies
	popup.set_item_id(0, database.ItemCategory.WEAPON)
	popup.set_item_id(1, database.ItemCategory.ARMOR)
	popup.set_item_id(2, database.ItemCategory.CONSUMABLE)
	popup.set_item_id(3, database.ItemCategory.MATERIAL)
	popup.set_item_id(4, database.ItemCategory.SPECIAL)

# Update index and items when pressing category item
func category_id_pressed(var id : int):
	
	# Update category
	category_idx = id
	category.text = category.get_popup().get_item_text(id - 1)

	# Log
	print("[questie]: set item_category to " + var2str(category_idx))

	# Update items
	load_items_from_database(id)

func item_id_pressed(var id : int):

	# update item information
	item_idx = id
	item.text = item.get_popup().get_item_text(id)

	var data = database.find_data_by_slot(item_idx, category_idx)
	uuid.text = database.find_data_by_slot(item_idx, category_idx).uuid

	# Log
	print("[questie]: set item to " + item.text + " with uuid: " + uuid.text)

	emit_signal("item_selected", data.uuid, category_idx, data)

func destroy():
	emit_signal("destruction_requested")

func _enter_tree():

	# Get references from scene
	uuid = $HBoxContainer/uuid
	item = $HBoxContainer/item
	category = $HBoxContainer/category
	delete = $HBoxContainer/delete

	# Initialize menu items
	load_items_from_database(database.ItemCategory.WEAPON)
	load_categories_from_database()
	category.text = "Weapon"

	# Subscribe events
	category.get_popup().connect("id_pressed", self, "category_id_pressed")
	item.get_popup().connect("id_pressed", self, "item_id_pressed")
	delete.connect("button_down", self, "destroy")

func _exit_tree():
	category.get_popup().disconnect("id_pressed", self, "category_id_pressed")
	item.get_popup().disconnect("id_pressed", self, "item_id_pressed")
	delete.disconnect("button_down", self, "destroy")








