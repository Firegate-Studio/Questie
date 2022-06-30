tool
class_name InventoryWorkspace
extends Control

var inventory_path : LineEdit                   # A line edit containing the path to the inventory
var inventory_picker_btn : ToolButton           # A button to call a menu to select the player inventory from file system
var inventory_preview : Viewport                # A viewport that loads the inventory selected
var inventory_picker : FileDialog               # A file dialogue popup to select an inventory

# Save file for settings data
var saves = preload("res://questie/settings.tres")

func load_inventory_in_viewport():

	# Unloas all children if count > 0
	if inventory_preview.get_child_count() > 0:
		inventory_preview.remove_child(inventory_preview.get_child(0))
	
	# Check if path is valid
	if inventory_path.text == "":
		return

	# Load new item
	inventory_preview.add_child(load(inventory_path.text).instance())

	# Log
	print("[questie]: loaded new inventory in preview viewport")

func pickup_button_pressed():

	# Show inventory popup menu
	inventory_picker.show()

func on_inventory_selected(var path : String):

	var temp = load(path).instance()
		
	if not temp is InventoryBase:
		# Log error
		print("[questie]: inventory selected at path: " + path + " is not an inventory")
		temp.free()     # release asset
		return

	temp.free()

	#update line path
	inventory_path.text = path

	load_inventory_in_viewport()

	save_data()

func save_data():
	saves.items_settings.inventory = inventory_path.text
	ResourceSaver.save("res://questie/settings.tres", saves)

func _enter_tree():

	# Get references
	inventory_path = $"MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/Inventory Path"
	inventory_picker_btn = $"MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/inventory pickup"
	inventory_preview = $MarginContainer/ScrollContainer/VBoxContainer/Panel/ViewportContainer/Viewport
	inventory_picker = $"Inventory Picker"

	# Subscribe events
	inventory_picker_btn.connect("button_down", self, "pickup_button_pressed")
	inventory_picker.connect("file_selected", self, "on_inventory_selected")

func _exit_tree():

	inventory_picker_btn.disconnect("button_down", self, "pickup_button_pressed")

