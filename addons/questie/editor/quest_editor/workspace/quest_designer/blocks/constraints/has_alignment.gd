tool
extends GraphNode
class_name ConstraintBlock_HasAlignment

var character_database : CharacterDatabase

var characters_menu : OptionButton
var min_alignment : SpinBox
var max_alignment : SpinBox

var selected_character_index : int = 0
var current_min : float
var current_max : float

func _enter_tree():

	character_database = ResourceLoader.load("res://questie/characters-db.tres")
	if not character_database:
		print("[Questie]: can not load characters database!")
		return

	characters_menu = $HBoxContainer/CharactersButton
	min_alignment = $HBoxContainer/VBoxContainer/HBoxContainer/MinAlignment
	max_alignment = $HBoxContainer/VBoxContainer/HBoxContainer2/MaxAlignment

	load_characters_from_database()

	characters_menu.connect("pressed", self, "on_character_menu_pressed")
	characters_menu.get_popup().connect("id_pressed", self, "on_character_item_selected")
	min_alignment.connect("value_changed", self, "on_min_alignment_changed")
	max_alignment.connect("value_changed", self, "on_max_alignment_changed")

func _exit_tree():
	characters_menu.disconnect("pressed", self, "on_character_menu_pressed")
	characters_menu.get_popup().disconnect("id_pressed", self, "on_character_item_selected")
	min_alignment.disconnect("value_changed", self, "on_min_alignment_changed")
	max_alignment.disconnect("value_changed", self, "on_max_alignment_changed")

func load_characters_from_database():
	var popup = characters_menu.get_popup()
	popup.clear()

	for character_data in character_database.characters:
		popup.add_item(character_data.title)

func on_character_menu_pressed():
	load_characters_from_database()

func on_character_item_selected(character_index : int):
	selected_character_index = character_index;
	characters_menu.text = characters_menu.get_popup().get_item_text(character_index)

func on_min_alignment_changed(new_value : float):
	current_min = new_value

func on_max_alignment_changed(new_value : float):
	current_max = new_value
