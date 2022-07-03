tool
extends Panel

signal item_selected(item_uuid, block_part)
signal category_selected(category_idx, block_part)
signal quantity_changed(quantity, block_part)
signal delete_part_requested(block_part)

var database = preload("res://questie/item-db.tres")

var item : MenuButton
var category : MenuButton
var quantity : SpinBox
var delete_btn : Button

var item_idx : int = 0
var category_idx : int = 1

func load_item_categories()->void:

	var popup = category.get_popup()
	popup.clear()                   # removes all items to avoid duplicates
	
	# Add items
	popup.add_item("Weapons")
	popup.add_item("Armors")
	popup.add_item("Consumables")
	popup.add_item("Materials")
	popup.add_item("Specials")

	# Remap index map to fit ItemCategory from database
	popup.set_item_id(0, database.ItemCategory.WEAPON)
	popup.set_item_id(1, database.ItemCategory.ARMOR)
	popup.set_item_id(2, database.ItemCategory.CONSUMABLE)
	popup.set_item_id(3, database.ItemCategory.MATERIAL)
	popup.set_item_id(4, database.ItemCategory.SPECIAL)

func load_items_from_database(var category : int)->void:

	var popup = item.get_popup()
	popup.clear()               # removes all stored items to avoid duplicated while updating

	# Generate items
	match category:
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
				print(context.title)
		database.ItemCategory.SPECIAL:
			for context in database.specials:
				popup.add_item(context.title)

func item_id_pressed(var idx : int):

	item.text = item.get_popup().get_item_text(idx)
	var item_data = database.find_data_by_slot(idx, category_idx)
	if not item_data:
		# log error
		print("[questie]: can't retrieve item data from slot")
		return
	
	item_idx = idx
	emit_signal("item_selected", item_data.uuid, self)

func category_id_pressed(var idx : int):

	category_idx = idx
	load_items_from_database(category_idx)
	
	category.text = category.get_popup().get_item_text(idx - 1)
	emit_signal("category_selected", category_idx, self)


func quantity_changed(var amount ):
	quantity.value = amount
	emit_signal("quantity_changed", amount, self)

func delete_part():
	emit_signal("delete_part_requested", self)

func _enter_tree():
	
	# Get references from scene
	item = $HBoxContainer/item
	category = $HBoxContainer/category
	quantity = $HBoxContainer/quantity
	delete_btn = $HBoxContainer/delete

	# initial setup
	load_item_categories()
	load_items_from_database(category_idx)
	category.text = category.get_popup().get_item_text(category_idx - 1)

	# Subscribe events
	item.get_popup().connect("id_pressed", self, "item_id_pressed")
	category.get_popup().connect("id_pressed", self, "category_id_pressed")
	quantity.connect("value_changed", self, "quantity_changed")
	delete_btn.connect("button_down", self, "delete_part")
