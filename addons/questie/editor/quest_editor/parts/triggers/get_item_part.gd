tool
extends Panel

# @brief				called when the user select the item from scene
# @param item_uuid		the uuid of the item selected
# @param category		the category of the item into item database
# @param data			item information stored into item database
signal item_selected(item_id, data)
signal destruction_requested()

var item_menu : MenuButton
var delete : Button

var database = preload("res://questie/item-db.tres")

var category_idx = 1        # the item index for [database.ItemCategory]
var item_idx = -1           # the slot filled from item

# @brief                    Loads popup items by category
# @param type               item category
func load_items_from_database():

	var popup = item_menu.get_popup()
	popup.clear()               # Removes all items

	for data in database.items:
		popup.add_item(data.name)

func item_id_pressed(id : int):

	# update item information
	item_idx = id
	item_menu.text = item_menu.get_popup().get_item_text(id)

	var data = database.items[id]

	# Log
	print("[questie]: set item to " + data.name + " with uuid: " + data.id)

	emit_signal("item_selected", data.id, data)

func destroy():
	emit_signal("destruction_requested")

func _enter_tree():

	# Get references from scene
	item_menu = $HBoxContainer/item
	delete = $HBoxContainer/delete

	# Initialize menu items
	load_items_from_database()

	# Subscribe events
	item_menu.get_popup().connect("id_pressed", self, "item_id_pressed")
	delete.connect("button_down", self, "destroy")

func _exit_tree():
	item_menu.get_popup().disconnect("id_pressed", self, "item_id_pressed")
	delete.disconnect("button_down", self, "destroy")








