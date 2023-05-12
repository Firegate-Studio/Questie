tool
extends Control

var new_item_btn : Button
var container : GridContainer

# the character identifier to find the related item from the characters database
var _character_id : String

# the slot to add to the grid container
var slot_asset = preload("res://addons/questie/editor/character_editor/workspace/inventory/inventory_item_slot.tscn")

# the character database
var database = preload("res://questie/characters-db.tres")

var item_selection_popup = load("res://addons/questie/editor/character_editor/item_selection_popup.tscn").instance()

# the selected item who has opened the item selection popup
var selected_slot

func _enter_tree():
	new_item_btn = $"VBoxContainer/HBoxContainer/New Item Button"
	container = $VBoxContainer/ScrollContainer/GridContainer
	item_selection_popup = $"Item Selection Popup"

	new_item_btn.connect("button_down", self, "on_new_item")
	item_selection_popup.connect("item_selected", self, "on_item_confirmed")

func _exit_tree():
	new_item_btn.disconnect("button_down", self, "on_new_item")

# called when an item is confirmed from the item selection popup - click ok
func on_item_confirmed(id, name, icon):
	selected_slot.item_id = id
	selected_slot._item_name.text = name
	selected_slot._icon.texture = icon

	# modify database values
	var item_database = load("res://questie/item-db.tres")
	var category = item_database.get_item_category(id)
	var item_index = selected_slot.get_index()
	var inventory_data = database.get_character_data(_character_id).inventory[item_index]
	inventory_data.id = id
	inventory_data.name = name
	inventory_data.icon = icon.resource_path
	ResourceSaver.save("res://questie/characters-db.tres", database)

	selected_slot = null

func on_new_item():
	var slot = slot_asset.instance()

	slot.connect("button_down", self, "on_item_slot_clicked", [slot])
	slot.connect("slot_deletion_requested", self, "on_slot_deletion")

	# generate and stores data
	var data = load("res://addons/questie/editor/character_editor/data/inventory_item.gd").new()
	database.get_character_data(_character_id).add_item_data_to_inventory(data)
	ResourceSaver.save("res://questie/characters-db.tres", database)

	container.add_child(slot)

func on_item_slot_clicked(slot):
	selected_slot = slot
	item_selection_popup.popup_centered(Vector2(1920/2, 1080/2))

func on_slot_deletion(item_id):
	var inventory_data = database.get_character_data(_character_id).inventory
	for data in inventory_data:
		if not data.id == item_id: continue

		inventory_data.erase(data)
		print("[Questie]: remove inventory item with identifier: " + item_id)
		break

	ResourceSaver.save("res://questie/characters-db.tres", database)
	

func setup(character_id):
	_character_id = character_id

	# clean viewport
	for item in container.get_children():
		item.queue_free()
	
	# load stored items from database
	for data in database.get_character_data(character_id).inventory:
		var slot = slot_asset.instance()
		container.add_child(slot)
		slot.item_id = data.id
		slot._item_name.text = data.name
		slot._icon.texture = load(data.icon)
		slot._quantity.value = data.quantity

		slot.connect("button_down", self, "on_item_slot_clicked", [slot])
		slot.connect("slot_deletion_requested", self, "on_slot_deletion")

	

	
	
	



