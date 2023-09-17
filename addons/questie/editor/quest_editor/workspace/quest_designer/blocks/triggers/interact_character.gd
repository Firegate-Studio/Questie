tool
extends GraphNode
class_name TriggerBlock_InteractCharacter

signal character_selected(character_index, character_id)

var character_menu : MenuButton

var character_index : int = -1
var character_id : String = ""

var character_database : CharacterDatabase = null

func _enter_tree(): 
	character_database = ResourceLoader.load("res://questie/characters-db.tres")
	if not character_database:
		print("[Questie]: can't load character database for interact character trigger block")
		return

	character_menu = $"HBoxContainer/Character Menu"

	# initalize
	load_character_items_from_database()
	if character_database.characters.size() > 0:
		character_index = 0
		character_id = character_database.characters[0].id
		character_menu.text = character_database.characters[0].title

	# subscribe signals
	character_menu.connect("pressed", self, "on_character_menu_pressed")
	character_menu.get_popup().connect("id_pressed", self, "on_character_item_selected")

func _exit_tree():
	character_menu.disconnect("pressed", self, "on_character_menu_pressed")
	character_menu.get_popup().disconnect("id_pressed", self, "on_character_item_selected")

func load_character_items_from_database():
	var popup = character_menu.get_popup()
	popup.clear()

	for character_data in character_database.characters:
		popup.add_item(character_data.title)

func on_character_menu_pressed():
	load_character_items_from_database()

func on_character_item_selected(index : int):
	character_index = index
	character_id = character_database.characters[index].id
	character_menu.text = character_database.characters[index].title
	emit_signal("character_selected", character_index, character_id)

