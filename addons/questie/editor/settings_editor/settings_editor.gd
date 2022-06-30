tool
extends Control

var hierarchy_tree
var inventory_workspace

# The workspace that is active in this very moment
var current_workspace

func load_workspace(var workspace):
	
	var database = load("res://questie/settings.tres")
	
	if workspace is InventoryWorkspace:
		inventory_workspace.inventory_path.text = database.items_settings.inventory
		inventory_workspace.load_inventory_in_viewport()

func inventory_selected(var item):

	# Hide workspace if valid
	if current_workspace:
		current_workspace.hide()
		
	current_workspace = inventory_workspace
	current_workspace.show()

	load_workspace(current_workspace)

func invalid_item_selection():
	if current_workspace: 
		current_workspace.hide()

func _enter_tree():

	hierarchy_tree = $HBoxContainer/Hierarchy/ScrollContainer/Tree
	inventory_workspace = $"HBoxContainer/Inventory Workspace"

	# Subscribe Events
	hierarchy_tree.connect("inventory_selected", self, "inventory_selected")
	hierarchy_tree.connect("invalid_selection", self, "invalid_item_selection")

