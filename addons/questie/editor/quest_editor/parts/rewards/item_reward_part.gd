tool
extends Panel

signal item_selected(id, block_part)
signal quantity_changed(quantity, block_part)
signal delete_part_requested(block_part)

var item_database = preload("res://questie/item-db.tres")

var item_menu : MenuButton
var quantity_box : SpinBox
var delete_button : Button

var item_idx : int = 0
var category_idx : int = 1

func _enter_tree(): 

	# get references from scene
	item_menu = $"HBoxContainer/Item Menu"
	quantity_box = $"HBoxContainer/Quantity Box"
	delete_button = $"HBoxContainer/Delete Button"

	# Setup
	load_items_from_database()

	# Subscribe events
	item_menu.get_popup().connect("id_pressed", self, "item_id_selected")
	quantity_box.connect("value_changed", self, "quantity_changed")
	delete_button.connect("button_down", self, "delete_part")

func _exit_tree(): 
	item_menu.get_popup().disconnect("id_pressed", self, "item_id_selected")
	quantity_box.disconnect("value_changed", self, "quantity_changed")
	delete_button.disconnect("button_down", self, "delete_part")

func load_items_from_database()->void:

	var popup = item_menu.get_popup()
	popup.clear()

	# Generate Items
	for item in item_database.items:
		popup.add_item(item.name)

func item_id_selected(var id : int):
	item_menu.text = item_menu.get_popup().get_item_text(id)
	var item_data = item_database.items[id]
	if not item_data:
		# log error
		print("[Questie]: can't retrieve item data from slot")
		return

	item_idx = id
	emit_signal("item_selected", item_data.id, self)
	
	print("[Questie]: selected " + item_data.name)

func quantity_changed(amount):
	quantity_box.value = amount
	emit_signal("quantity_changed", amount, self)

func delete_part(): emit_signal("delete_part_requested", self)    
