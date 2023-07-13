tool
extends Panel

signal item_selected(item_uuid, block_part)
signal category_selected(category_idx, block_part)
signal quantity_changed(quantity, block_part)
signal delete_part_requested(block_part)

var database = preload("res://questie/item-db.tres")

var item : MenuButton
var quantity : SpinBox
var delete_btn : Button

var item_idx : int = 0
var category_idx : int = 1

func load_items_from_database()->void:

	var popup = item.get_popup()
	popup.clear()               # removes all stored items to avoid duplicated while updating

	# Generate items
	for data in database.items:
		popup.add_item(data.name)

func item_id_pressed(var idx : int):

	item.text = item.get_popup().get_item_text(idx)
	var item_data = database.items[idx]
	if not item_data:
		# log error
		print("[questie]: can't retrieve item data from slot")
		return
	
	item_idx = idx
	emit_signal("item_selected", item_data.id, self)

func quantity_changed(var amount ):
	quantity.value = amount
	emit_signal("quantity_changed", amount, self)

func delete_part():
	emit_signal("delete_part_requested", self)

func _enter_tree():
	
	# Get references from scene
	item = $HBoxContainer/item
	quantity = $HBoxContainer/quantity
	delete_btn = $HBoxContainer/delete

	# initial setup
	load_items_from_database()

	# Subscribe events
	item.get_popup().connect("id_pressed", self, "item_id_pressed")
	quantity.connect("value_changed", self, "quantity_changed")
	delete_btn.connect("button_down", self, "delete_part")
	
func _exit_tree():
	item.get_popup().disconnect("id_pressed", self, "item_id_pressed")
	quantity.disconnect("value_changed", self, "quantity_changed")
	delete_btn.disconnect("button_down", self, "delete_part")
