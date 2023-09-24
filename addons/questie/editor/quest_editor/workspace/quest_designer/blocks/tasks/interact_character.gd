tool
extends GraphNode
class_name TaskBlock_InteractCharacter

signal character_selected(character_index, character_id)

var character_database : CharacterDatabase

var character_menu : MenuButton

var selected_character_index : int = -1
var selected_character_id : String

func _enter_tree():
	character_database = ResourceLoader.load("res://questie/characters-db.tres")
	if not character_database:
		print("[Questie]: Can't load character database for TaskBlock_InteractCharacter")
		return

	character_menu = $HBoxContainer/CharacterMenu

	initialize()

	character_menu.connect("pressed", self, "on_character_menu_pressed")
	character_menu.get_popup().connect("id_pressed", self, "on_character_selected")

func _exit_tree():
	character_menu.disconnect("pressed", self, "on_character_menu_pressed")
	character_menu.get_popup().disconnect("id_pressed", self, "on_character_selected")

func initialize():
	load_character_items_from_database()
	if character_database.characters.size() > 0:
		selected_character_index = 0
		selected_character_id = character_database.characters[0].id
		character_menu.text = character_database.characters[0].title
		

func load_character_items_from_database():
	var popup = character_menu.get_popup()
	popup.clear()

	for data in character_database.characters:
		popup.add_item(data.title)

func on_character_menu_pressed():
	load_character_items_from_database()

func on_character_selected(index : int):
	selected_character_index = index
	selected_character_id = character_database.characters[index].id
	character_menu.text = character_database.characters[index].title
	emit_signal("character_selected", index, selected_character_id)
