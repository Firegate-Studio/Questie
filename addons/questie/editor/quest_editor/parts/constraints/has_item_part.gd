tool
extends Control

signal category_changed(part, category)
signal item_changed(item_id)
signal quantity_changed(part, amount)
signal delete_part(part)

var database

var item : MenuButton
var quantity : SpinBox
var delete : Button

func refresh():

	var popup = item.get_popup()
	popup.clear()

	for item in database.items:
		popup.add_item(item.name)

func item_selected(var index):

	var item_id = ItemsCollection.items_map[index]
	print("[Questie]: selected item with identifier " + item_id)

	# update text
	item.text = item.get_popup().get_item_text(index)

	# notify
	emit_signal("item_changed", item_id)

func quantity_override(quantity): 
	emit_signal("quantity_changed", self, quantity)

func delete_request(): 
	emit_signal("delete_part", self)

func _enter_tree():

	# Get reference from interface
	item = $HBoxContainer/Item
	quantity = $HBoxContainer/Quantity
	delete = $"HBoxContainer/Delete"

	# Subscribe events
	item.get_popup().connect("id_pressed", self, "item_selected")
	quantity.connect("value_changed", self, "quantity_override")
	delete.connect("button_down", self, "delete_request")

	# Load database
	database = load("res://questie/item-db.tres")

	refresh()
