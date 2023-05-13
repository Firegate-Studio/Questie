tool
extends Panel

var _name : LineEdit
var _surname : LineEdit
var _biography : TextEdit
var _backgorund : TextEdit
var _inventory_checkbox : CheckBox
var _loot_checkbox : CheckBox
var _shop_checkbox : CheckBox
var _tab_container : TabContainer
var _inventory
var _shop
var _loot 

# the identifier of the character inside the database
var id : String

# the character database
var database = preload("res://questie/characters-db.tres")

func _enter_tree(): 
	_name = $ScrollContainer/VBoxContainer/HBoxContainer/Name
	_surname = $ScrollContainer/VBoxContainer/HBoxContainer2/Surname
	_biography = $ScrollContainer/VBoxContainer/Biography
	_backgorund = $ScrollContainer/VBoxContainer/Background
	_inventory_checkbox = $"ScrollContainer/VBoxContainer/HBoxContainer3/Inventory Checkbox"
	_loot_checkbox = $"ScrollContainer/VBoxContainer/HBoxContainer3/Loot Checkbox"
	_shop_checkbox = $"ScrollContainer/VBoxContainer/HBoxContainer3/Shop Checkbox"
	_tab_container = $"ScrollContainer/VBoxContainer/TabContainer"
	_inventory = $"ScrollContainer/VBoxContainer/TabContainer/Inventory"
	_shop = $ScrollContainer/VBoxContainer/TabContainer/Shop
	_loot = $ScrollContainer/VBoxContainer/TabContainer/Loot

	_name.connect("text_changed", self, "on_name_changed")
	_surname.connect("text_changed", self, "on_surname_changed")
	_biography.connect("text_changed", self, "on_biography_changed")
	_backgorund.connect("text_changed", self, "on_background_changed")
	_inventory_checkbox.connect("toggled", self, "on_inventory_checkbox_changed")
	_loot_checkbox.connect("toggled", self, "on_loot_checkbox_changed")
	_shop_checkbox.connect("toggled", self, "on_shop_checkbox_changed")

func _exit_tree():
	_name.disconnect("text_changed", self, "on_name_changed")
	_surname.disconnect("text_changed", self, "on_surname_changed")
	_biography.disconnect("text_changed", self, "on_biography_changed")
	_backgorund.disconnect("text_changed", self, "on_background_changed")
	_inventory_checkbox.disconnect("toggled", self, "on_inventory_checkbox_changed")
	_loot_checkbox.disconnect("toggled", self, "on_loot_checkbox_changed")
	_shop_checkbox.disconnect("toggled", self, "on_shop_checkbox_changed")

func on_name_changed(text): 
	var data = database.get_character_data(id)
	if not data:
		print("[Questie]: can not set new character name - character not found!")
		return

	data.name = text
	ResourceSaver.save("res://questie/characters-db.tres", database)
	print("[Questie]: set character name to " + text)

func on_surname_changed(text): 
	var data = database.get_character_data(id)
	if not data:
		print("[Questie]: can not set new character name - character not found!")
		return

	data.surname = text
	ResourceSaver.save("res://questie/characters-db.tres", database)
	print("[Questie]: set character surname to " + text)

func on_biography_changed():
	var data = database.get_character_data(id)
	if not data:
		print("[Questie]: can not set new character name - character not found!")
		return

	data.biography = _biography.text
	ResourceSaver.save("res://questie/characters-db.tres", database)
	print("[Questie]: set character biography to " + _biography.text)

func on_background_changed():
	var data = database.get_character_data(id)
	if not data:
		print("[Questie]: can not set new character name - character not found!")
		return

	data.background = _backgorund.text
	ResourceSaver.save("res://questie/characters-db.tres", database)
	print("[Questie]: set character background to " + _backgorund.text)

func on_inventory_checkbox_changed(pressed): 
	var data = database.get_character_data(id)
	if not data:
		print("[Questie]: can not set new character name - character not found!")
		return

	data.has_inventory = pressed
	ResourceSaver.save("res://questie/characters-db.tres", database)
	print("[Questie]: set has_inventory to " + var2str(pressed))

func on_loot_checkbox_changed(pressed): 
	var data = database.get_character_data(id)
	if not data:
		print("[Questie]: can not set new character name - character not found!")
		return

	data.has_loot = pressed
	ResourceSaver.save("res://questie/characters-db.tres", database)
	print("[Questie]: set has_loot to " + var2str(pressed))

func on_shop_checkbox_changed(pressed): 
	var data = database.get_character_data(id)
	if not data:
		print("[Questie]: can not set new character name - character not found!")
		return

	data.is_vendor = pressed
	ResourceSaver.save("res://questie/characters-db.tres", database)
	print("[Questie]: set has_shop to " + var2str(pressed))

# fill the interface information using data store in characters-db
func setup(character_id): 
	var data = database.get_character_data(character_id)
	if not data:
		print("[Questie]: can not find character in database for the following identifier: " + character_id)
		return

	id = character_id
	_name.text = data.name
	_surname.text = data.surname
	_biography.text = data.biography
	_backgorund.text = data.background
	_inventory_checkbox.pressed = data.has_inventory
	_shop_checkbox.pressed = data.is_vendor
	_loot_checkbox.pressed = data.has_loot
	
	_inventory.setup(id)
	_shop.setup(id)
	_loot.setup(id)
