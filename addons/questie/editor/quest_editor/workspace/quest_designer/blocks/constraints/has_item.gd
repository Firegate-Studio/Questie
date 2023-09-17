tool
extends GraphNode
class_name ConstraintBlock_HasItem

var item_db : ItemDatabase

var item_menu : MenuButton
var item_name : Label
var item_quantity : SpinBox

var selected_item_id : String
var selected_item_index : int = -1;
var current_quantity : int = 0

func _enter_tree(): 

	item_menu = $HBoxContainer/VBoxContainer/ItemMenu
	item_name = $"HBoxContainer/VBoxContainer/Item Name"
	item_quantity = $HBoxContainer/Quantity

	item_db = ResourceLoader.load("res://questie/item-db.tres")
	if not item_db:
		print("[Questie]: unable to load the item database")
		return

	load_items_from_database()

	item_menu.connect("pressed", self, "on_item_menu_pressed")
	item_menu.get_popup().connect("id_pressed", self, "on_item_selected")
	item_quantity.connect("value_changed", self, "on_item_quantity_changed")

func _exit_tree(): 
	item_menu.disconnect("pressed", self, "on_item_menu_pressed")
	item_menu.get_popup().disconnect("id_pressed", self, "on_item_selected")
	item_quantity.disconnect("value_changed", self, "on_item_quantity_changed")

func load_items_from_database():
	var popup = item_menu.get_popup()
	popup.clear()

	for item in item_db.items:
		popup.add_item(item.name)

func on_item_menu_pressed():
	load_items_from_database()

func on_item_selected(item_index : int):
	selected_item_index = item_index
	selected_item_id = item_db.items[item_index].id
	item_menu.icon = item_db.items[item_index].icon
	item_name.text = item_menu.get_popup().get_item_text(item_index)

func on_item_quantity_changed(new_value : float):
	current_quantity = new_value
	item_quantity.value = new_value
