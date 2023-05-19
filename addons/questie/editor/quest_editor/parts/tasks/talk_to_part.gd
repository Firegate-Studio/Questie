tool
extends Panel

signal character_selected(character_id, character_index)
signal deletion_request()

# the identifier of the character inside the character database
var character_id : String

var character_index : int

var character_icon = load("res://addons/questie/editor/icons/character_32x32.png")

var database = preload("res://questie/characters-db.tres")

var character_menu : MenuButton
var delete_button : Button

func _enter_tree():
	character_menu = $HBoxContainer/character
	delete_button = $HBoxContainer/delete

	character_menu.get_popup().connect("id_pressed", self, "on_character_selected")
	delete_button.connect("button_down", self, "on_deletion_request")

	load_characters_from_database()

func _exit_tree():
	character_menu.get_popup().disconnect("id_pressed", self, "on_character_selected")
	delete_button.disconnect("button_down", self, "on_deletion_request")

func on_character_selected(id):
	var data = database.characters[id]
	character_index = id
	character_id = data.id;
	character_menu.text = data.title
	print("[Questie]: set character to " + data.title)

	emit_signal("character_selected", character_id, character_index)

func on_deletion_request():
	print("[Questie]: deletion request...")
	emit_signal("deletion_request")

func load_characters_from_database():
	var popup = character_menu.get_popup()

	# clear item
	popup.clear()

	# generate items from db
	for character in database.characters:
		popup.add_icon_item(character_icon, character.title)

func autoload(task_data):

	# pass information
	character_id = task_data.character_id
	character_index = task_data.character_index

	# update interface
	if character_index == -1:
		character_menu.text = "select character"
	else:
		character_menu.text = database.characters[character_index].title
