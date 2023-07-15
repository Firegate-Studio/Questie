tool 
extends Control

# the button to request a new loot item
var new_loot_button : Button    

# the containers for all the loot items
var container : GridContainer

# the loot selection window popup
var loot_selection_popup 

# the selected slot who has called the selection popup
var selected_slot

var slot_asset = preload("res://addons/questie/editor/character_editor/workspace/loot/slot_item.tscn")

# the character identifier to find this loot item inside the characters database
var _character_id : String

# the character database
var character_database = preload("res://questie/characters-db.tres")

func _enter_tree():
	new_loot_button = $"VBoxContainer/HBoxContainer/New Loot Button"
	container = $"VBoxContainer/ScrollContainer/Items Container"
	loot_selection_popup = $"loot selection popup"

	new_loot_button.connect("button_down", self, "on_new_loot_item")
	loot_selection_popup.connect("item_selected", self, "on_item_confirmed")

func _exit_tree(): pass

func on_item_confirmed(id, name, icon):

	# retrieve data
	var slot_index = selected_slot.get_index()
	var data = character_database.get_character_data(_character_id).loot[slot_index]

	# update data
	data.id = id
	data.name = name
	data.icon = icon
	ResourceSaver.save("res://questie/characters-db.tres", character_database)

	# update slot
	selected_slot._name.text = name
	selected_slot._icon.texture = icon

	selected_slot = null

func on_new_loot_item():
	var slot = slot_asset.instance()
	container.add_child(slot)

	# generates data
	var data = load("res://addons/questie/editor/character_editor/data/loot_item.gd").new()
	data.quantity = 1
	var loot_inventory = character_database.get_character_data(_character_id).loot
	loot_inventory.push_back(data)
	ResourceSaver.save("res://questie/characters-db.tres", character_database)

	# subscribe events
	slot.connect("button_down", self, "on_loot_item_clicked", [slot])
	slot.connect("deletion_requested", self, "on_loot_item_deletion", [slot])
	slot.connect("quantity_changed", self, "on_loot_item_quantity_changed", [slot])
	slot.connect("percentage_changed", self, "on_loot_item_percentage_changed", [slot])

func on_loot_item_clicked(slot):
	selected_slot = slot
	loot_selection_popup.popup_centered(Vector2(1920/2, 1080/2))

func on_loot_item_deletion(slot):
	# get data
	var slot_index = slot.get_index()
	var data = character_database.get_character_data(_character_id).loot[slot_index]

	# get slot inventory
	var slot_inventory = character_database.get_character_data(_character_id).loot

	# remove data
	slot_inventory.erase(data)
	ResourceSaver.save("res://questie/characters-db.tres", character_database)

	# clear viewport
	if selected_slot == slot: 
		selected_slot = null
	slot.queue_free()

func on_loot_item_quantity_changed(value, slot):

	# retrieve data
	var data = character_database.get_character_data(_character_id).loot[slot.get_index()]

	# update quantity
	data.quantity = value
	ResourceSaver.save("res://questie/characters-db.tres", character_database)

func on_loot_item_percentage_changed(percentage, slot):

	# retrieve data
	var data = character_database.get_character_data(_character_id).loot[slot.get_index()]

	# update data
	data.percentage = percentage
	ResourceSaver.save("res://questie/characters-db.tres", character_database)

func setup(character_id): 
	_character_id = character_id

	# clear viewport
	for child in container.get_children():
		child.queue_free()

	# load stored data
	var loot_inventory = character_database.get_character_data(_character_id).loot
	for data in loot_inventory:
		var slot = slot_asset.instance()
		container.add_child(slot)

		# update slot
		slot._name.text = data.name 
		slot._icon.texture = data.icon
		slot._quantity.value = data.quantity
		slot._percentage_slider.value = data.percentage
		slot._percentage_text.text = var2str(data.percentage)+"%"

		# subscribe events
		slot.connect("button_down", self, "on_loot_item_clicked", [slot])
		slot.connect("deletion_requested", self, "on_loot_item_deletion", [slot])
		slot.connect("quantity_changed", self, "on_loot_item_quantity_changed", [slot])
		slot.connect("percentage_changed", self, "on_loot_item_percentage_changed", [slot])
		
