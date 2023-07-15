tool
extends Control

# the button to create new items
var new_item_btn : Button

# container for the slot items
var container : GridContainer

# the character database
var character_database = preload("res://questie/characters-db.tres")

# the character identifier
var _character_id

var slot_asset = preload("res://addons/questie/editor/character_editor/workspace/shop/slot_item.tscn")

# the popup to select an item
var item_selector_popup

# the item slot current selected who has called the item selector popup
var selected_slot

func _enter_tree():
	new_item_btn = $"VBoxContainer/HBoxContainer/new item button"
	container = $VBoxContainer/ScrollContainer/GridContainer
	
	if not item_selector_popup:
		item_selector_popup = $"ConfirmationDialog"
		item_selector_popup.connect("item_selected", self, "on_item_confirmed")

	new_item_btn.connect("button_down", self, "on_new_item")
	
# called when the item selection popup confirmed the item selection
func on_item_confirmed(var id, var name, var icon):
	# the index of the current slot
	var slot_index = selected_slot.get_index()
	
	# get the shop inventory from character data
	var shop_inventory_data = character_database.get_character_data(_character_id).shop 
	
	# get item data from item database
	var item_database = load("res://questie/item-db.tres")
	var item_data = item_database.get_item(id)

	# update data information
	shop_inventory_data[slot_index].id = id
	shop_inventory_data[slot_index].name = name
	shop_inventory_data[slot_index].icon = icon.resource_path
	shop_inventory_data[slot_index].value = item_data.purchase_price
	ResourceSaver.save("res://questie/characters-db.tres", character_database)

	# update slot information
	selected_slot._name.text = name
	selected_slot._icon.texture = icon
	selected_slot._value.text = var2str(item_data.purchase_price)


func on_new_item():
	var slot = slot_asset.instance()
	container.add_child(slot)
	
	# subscribe events
	slot.connect("button_down", self, "on_item_clicked", [slot])
	slot.connect("quantity_changed", self, "on_item_quantity_changed", [slot])
	slot.connect("deletion_request", self, "on_item_deletion", [slot])
	
	# generating data
	var data = load("res://addons/questie/editor/character_editor/data/shop_item.gd").new()
	var character_data = character_database.get_character_data(_character_id)
	character_data.shop.push_back(data)
	ResourceSaver.save("res://questie/characters-db.tres", character_database)
	
	# log
	print("[Questie]: generated new shop data")
	
func on_item_clicked(slot):
	selected_slot = slot
	item_selector_popup.popup_centered(Vector2(1920/2, 1080/2))

func on_item_quantity_changed(value, slot):
	var slot_index = slot.get_index()

	# get slot data
	var data = character_database.get_character_data(_character_id).shop[slot_index]
	data.quantity = value
	print("[Questie]: set item quantity to " + var2str(value))
	ResourceSaver.save("res://questie/characters-db.tres", character_database)

func on_item_deletion(slot):
	var slot_index = slot.get_index()
	var shop = character_database.get_character_data(_character_id).shop
	var data = shop[slot_index]
	
	# remove data
	shop.erase(data)
	ResourceSaver.save("res://questie/characters-db.tres", character_database)

	# clear viewport
	slot.queue_free()

func setup(character_id):
	_character_id = character_id

	# remove all slots from interface
	for child in container.get_children():
		child.queue_free()
	
	# get shop items
	var shop = character_database.get_character_data(_character_id).shop

	# load stored items
	for item in shop:
		var slot = slot_asset.instance()
		container.add_child(slot)
		slot._name.text = item.name
		slot._icon.texture = load(item.icon)
		slot._value.text = var2str(item.value)
		slot._quantity.value = item.quantity
		
		# subscribe events
		slot.connect("button_down", self, "on_item_clicked", [slot])
		slot.connect("quantity_changed", self, "on_item_quantity_changed", [slot])
		slot.connect("deletion_request", self, "on_item_deletion", [slot])
		

	
   
