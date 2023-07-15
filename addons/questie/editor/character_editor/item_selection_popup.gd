tool
extends ConfirmationDialog

signal item_selected(id, name, icon)

onready var weapons_check : CheckButton
onready var armors_check : CheckButton
onready var consumables_check : CheckButton
onready var materials_check : CheckButton
onready var specials_check : CheckButton

# the search field to find items with a similar name
onready var search_line : LineEdit

onready var items_container : GridContainer

func _enter_tree():
	weapons_check = $"VBoxContainer/HBoxContainer2/weapon-check"
	armors_check = $"VBoxContainer/HBoxContainer2/armor-check"
	consumables_check = $"VBoxContainer/HBoxContainer2/consumables-check"
	materials_check = $"VBoxContainer/HBoxContainer2/materials-check"
	specials_check = $"VBoxContainer/HBoxContainer2/specials-check"

	search_line = $"VBoxContainer/HBoxContainer/search-line-text"
	items_container = $VBoxContainer/ScrollContainer/CenterContainer/GridContainer

	# subscribe events
	weapons_check.connect("pressed", self, "on_item_sorting_changed")
	armors_check.connect("pressed", self, "on_item_sorting_changed")
	consumables_check.connect("pressed", self, "on_item_sorting_changed")
	materials_check.connect("pressed", self, "on_item_sorting_changed")
	specials_check.connect("pressed", self, "on_item_sorting_changed")
	search_line.connect("text_changed", self, "on_searching_text_changed")

	connect("confirmed", self, "on_confirmation")

func on_item_sorting_changed():
	items_container.load_all_items(search_line.text)

func on_searching_text_changed(text): 
	print("[Questie]: searching " + text)
	items_container.load_all_items(text)

func on_confirmation():
	var selected_node = items_container.selected_node
	emit_signal("item_selected", selected_node._id, selected_node._name.text, selected_node._icon.texture)

