tool
extends Panel

signal item_selected(item_idx, category_idx)
signal category_selected(category_idx)
signal deletion_request()

# the item databases
var item_db = preload("res://questie/item-db.tres")

# category icons
var weapon_icon = preload("res://addons/questie/editor/icons/item.png")
var armor_icon = preload("res://addons/questie/editor/icons/armor.png")
var consumable_icon = preload("res://addons/questie/editor/icons/potion.png")
var material_icon = preload("res://addons/questie/editor/icons/material.png")
var special_icon = preload("res://addons/questie/editor/icons/coin.png")

var item_menu : MenuButton
var category_menu : MenuButton
var delete_button : Button

# the category index of the item
var category_idx : int

# the item position inside the database
var item_idx : int

func _enter_tree(): 
	item_menu = $"HBoxContainer/item menu"
	category_menu = $"HBoxContainer/category menu"
	delete_button = $"HBoxContainer/delete button"

	category_menu.get_popup().connect("id_pressed", self, "on_category_selected")
	item_menu.get_popup().connect("id_pressed", self, "on_item_selected")
	delete_button.connect("button_down", self, "on_delete_button_pressed")

	load_items_categories()

func on_category_selected(id):
	var popup = category_menu.get_popup()

	match id:
		ItemDatabase.ItemCategory.WEAPON:
			category_menu.icon = weapon_icon
			load_items_from_database(item_db.weapons)
		ItemDatabase.ItemCategory.ARMOR:
			category_menu.icon = armor_icon
			load_items_from_database(item_db.armors)
		ItemDatabase.ItemCategory.CONSUMABLE:
			category_menu.icon = consumable_icon
			load_items_from_database(item_db.consumables)
		ItemDatabase.ItemCategory.MATERIAL:
			category_menu.icon = material_icon
			load_items_from_database(item_db.materials)
		ItemDatabase.ItemCategory.SPECIAL:
			category_menu.icon = special_icon
			load_items_from_database(item_db.specials)

	category_idx = id
	print("[Questie]: set item category to " + var2str(id))

	# call event
	emit_signal("category_selected", category_idx)

func on_item_selected(id):
	var popup = item_menu.get_popup()

	match category_idx:
		ItemDatabase.ItemCategory.WEAPON:
			item_menu.icon = null
			item_menu.text = popup.get_item_text(id)
		ItemDatabase.ItemCategory.ARMOR:
			item_menu.icon = null
			item_menu.text = popup.get_item_text(id)
		ItemDatabase.ItemCategory.CONSUMABLE:
			item_menu.icon = null
			item_menu.text = popup.get_item_text(id)
		ItemDatabase.ItemCategory.MATERIAL:
			item_menu.icon = null
			item_menu.text = popup.get_item_text(id)
		ItemDatabase.ItemCategory.SPECIAL:
			item_menu.icon = null
			item_menu.text = popup.get_item_text(id)
			
	item_idx = id
	print("[Questie]: set item to " + item_menu.text)

	# call event
	emit_signal("item_selected", item_idx, category_idx)

func on_delete_button_pressed():
	print("[Questie]: part deletion requested")
	emit_signal("deletion_request")

func load_items_categories():
	var popup = category_menu.get_popup()
	popup.add_item("Weapons", ItemDatabase.ItemCategory.WEAPON)
	popup.add_item("Armors", ItemDatabase.ItemCategory.ARMOR)
	popup.add_item("Consumables", ItemDatabase.ItemCategory.CONSUMABLE)
	popup.add_item("Materials", ItemDatabase.ItemCategory.MATERIAL)
	popup.add_item("Specials", ItemDatabase.ItemCategory.SPECIAL)

func load_items_from_database(category):
	var popup = item_menu.get_popup()

	# clear previous items
	popup.clear()

	for item in category:
		popup.add_item(item.title)

func autoload(category, item_name = "", item_position = -1):
	
	# load category
	category_idx = category
	load_items_categories()
	match category:
		ItemDatabase.ItemCategory.WEAPON:
			category_menu.icon = weapon_icon
			load_items_from_database(item_db.weapons)
		ItemDatabase.ItemCategory.ARMOR:
			category_menu.icon = armor_icon
			load_items_from_database(item_db.armors)
		ItemDatabase.ItemCategory.CONSUMABLE:
			category_menu.icon = consumable_icon
			load_items_from_database(item_db.consumables)
		ItemDatabase.ItemCategory.MATERIAL:
			category_menu.icon = material_icon
			load_items_from_database(item_db.materials)
		ItemDatabase.ItemCategory.SPECIAL:
			category_menu.icon = special_icon
			load_items_from_database(item_db.specials)

	# load item
	if item_name == "":
		item_menu.icon = load("res://addons/questie/editor/icons/new_item_32x32.png")
	else:
		item_menu.icon = null 
		item_menu.text = item_name
	item_idx = item_position


