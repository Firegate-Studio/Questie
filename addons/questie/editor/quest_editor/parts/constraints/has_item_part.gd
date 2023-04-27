tool
extends Control

signal category_changed(part, category)
signal item_changed(item)
signal quantity_changed(part, amount)
signal delete_part(part)

var database

var item : MenuButton
var category : MenuButton
var quantity : SpinBox
var delete : Button

func refresh(var _category : int):

	var popup = item.get_popup()
	popup.clear()

	match _category:
		database.ItemCategory.WEAPON:
			for element in database.weapons:
				popup.add_item(element.title)
		database.ItemCategory.ARMOR:
			for element in database.armors:
				popup.add_item(element.title)
		database.ItemCategory.CONSUMABLE:
			for element in database.consumables:
				popup.add_item(element.title)
		database.ItemCategory.MATERIAL:
				for element in database.materials:
					popup.add_item(element.title)
		database.ItemCategory.SPECIAL:
				for element in database.specials:
					popup.add_item(element.title)
	
func category_selected(var id):

	category.text = category.get_popup().get_item_text(id)
	refresh(id +1)
	emit_signal("category_changed", self, id + 1)

func item_selected(var index):

	item.text = item.get_popup().get_item_text(index)

	var cat = -1

	# Find category index
	for item in category.get_popup().get_item_count():
		if not category.text == category.get_popup().get_item_text(item): continue

		# Set category id to match ItemCategory index
		cat = item + 1

		break
	
	# Check category index validation
	if cat == -1:
		print("[questie]: category index is not valid!")

		return

	emit_signal("item_changed", self, item.get_popup().get_item_id(index), cat)

func quantity_override(var quantity): 
	emit_signal("quantity_changed", self, quantity)

func delete_request(): 
	emit_signal("delete_part", self)

func _enter_tree():

	# Get reference from interface
	item = $HBoxContainer/Item
	category = $HBoxContainer/Category
	quantity = $HBoxContainer/Quantity
	delete = $"HBoxContainer/Delete"

	# Subscribe events
	category.get_popup().connect("id_pressed", self, "category_selected")
	item.get_popup().connect("id_pressed", self, "item_selected")
	quantity.connect("value_changed", self, "quantity_override")
	delete.connect("button_down", self, "delete_request")



	# Load database
	database = load("res://questie/item-db.tres")

func _ready():

	# Initialize category
	var popup = category.get_popup()
	popup.clear()
	popup.add_item("Weapon")
	popup.add_item("Armor")
	popup.add_item("Consumable")
	popup.add_item("Material")
	popup.add_item("Special")
