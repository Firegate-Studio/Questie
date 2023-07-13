tool
extends Panel

signal item_selected(item_id)
signal deletion_request()

# the item databases
var item_db = preload("res://questie/item-db.tres")

var item_menu : MenuButton
var delete_button : Button

# the category index of the item
var category_idx : int

# the item position inside the database
var item_idx : int

func _enter_tree(): 
	item_menu = $"HBoxContainer/item menu"
	delete_button = $"HBoxContainer/delete button"

	item_menu.get_popup().connect("id_pressed", self, "on_item_selected")
	delete_button.connect("button_down", self, "on_delete_button_pressed")
	
	load_items_from_database()

func _exit_tree():
	item_menu.get_popup().disconnect("id_pressed", self, "on_item_selected")
	delete_button.disconnect("button_down", self, "on_delete_button_pressed")

func on_item_selected(id):
	var popup = item_menu.get_popup()

	var data =item_db.items[id]
	item_menu.icon = data.icon
	item_menu.text = data.name
			
	item_idx = id
	print("[Questie]: set item to " + item_menu.text)

	# call event
	emit_signal("item_selected", data.id)

func on_delete_button_pressed():
	print("[Questie]: part deletion requested")
	emit_signal("deletion_request")

func load_items_from_database():
	var popup = item_menu.get_popup()

	# clear previous items
	popup.clear()

	for data in item_db.items:
		popup.add_item(data.name)

func autoload(data):

	item_menu.icon = data.icon
	item_menu.text = data.name


