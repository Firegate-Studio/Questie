tool
extends Panel

signal item_selected(id, block_part)
signal category_selected(id, block_part)
signal quantity_changed(quantity, block_part)
signal delete_part_requested(block_part)

var item_database = preload("res://questie/item-db.tres")

var item_menu : MenuButton
var category_menu : MenuButton
var quantity_box : SpinBox
var delete_button : Button

var item_idx : int = 0
var category_idx : int = 1

func _enter_tree(): 

	# get references from scene
	item_menu = $"HBoxContainer/Item Menu"
	category_menu = $"HBoxContainer/Category Menu"
	quantity_box = $"HBoxContainer/Quantity Box"
	delete_button = $"HBoxContainer/Delete Button"

	# Setup
	load_item_categories()
	load_items_from_database(category_idx)
	category_menu.text = category_menu.get_popup().get_item_text(category_idx - 1)

	# Subscribe events
	item_menu.get_popup().connect("id_pressed", self, "item_id_selected")
	category_menu.get_popup().connect("id_pressed", self, "category_id_selected")
	quantity_box.connect("value_changed", self, "quantity_changed")
	delete_button.connect("button_down", self, "delete_part")

func _exit_tree(): pass

func load_item_categories()->void:

	var popup = category_menu.get_popup()
	popup.clear()

	# Add Items
	popup.add_item("Weapons")
	popup.add_item("Armors")
	popup.add_item("Consumables")
	popup.add_item("Materials")
	popup.add_item("Specials")

	# Remap index map to fit ItemCategories from item database
	popup.set_item_id(0, item_database.ItemCategory.WEAPON)
	popup.set_item_id(1, item_database.ItemCategory.ARMOR)
	popup.set_item_id(2, item_database.ItemCategory.CONSUMABLE)
	popup.set_item_id(3, item_database.ItemCategory.MATERIAL)
	popup.set_item_id(4, item_database.ItemCategory.SPECIAL)

func load_items_from_database(category : int)->void:

	var popup = item_menu.get_popup()
	popup.clear()

	# Generate Items
	match category:
		item_database.ItemCategory.WEAPON:
			for weapon in item_database.weapons:
				popup.add_item(weapon.title)
		item_database.ItemCategory.ARMOR:
			for armor in item_database.armors:
				popup.add_item(armor.title)
		item_database.ItemCategory.CONSUMABLE:
			for consumable in item_database.consumables:
				popup.add_item(consumable.title)
		item_database.ItemCategory.MATERIAL:
			for material in item_database.materials:
				popup.add_item(material.title)
		item_database.ItemCategory.SPECIAL:
			for special in item_database.specials:
				popup.add_item(special.title)

func item_id_selected(var id : int):
	item_menu.text = item_menu.get_popup().get_item_text(id)
	var item_data = item_database.find_data_by_slot(id, category_idx)
	if not item_data:
		# log error
		print("[Questie]: can't retrieve item data from slot")
		return

	item_idx = id
	emit_signal("item_selected", item_data.uuid, self)

func category_id_selected(id : int):
	category_idx = id
	load_items_from_database(category_idx)

	category_menu.text = category_menu.get_popup().get_item_text(id - 1)
	emit_signal("category_selected", category_idx, self)

func quantity_changed(amount):
	quantity_box.value = amount
	emit_signal("quantity_changed", amount, self)

func delete_part(): emit_signal("delete_part_requested", self)    
