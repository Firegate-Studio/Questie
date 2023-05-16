tool
extends Panel

signal character_selected(character_id, character_idx)
signal deletion_request()

var character_menu : MenuButton
var delete_button : Button

# the default icon for the character menu
var default_icon = preload("res://addons/questie/editor/icons/character_32x32.png")

# the characters database
var character_db = preload("res://questie/characters-db.tres")

# the index of the selected character
var character_idx : int

# the identifier of the character
var character_id : String

func _enter_tree():
	character_menu = $"HBoxContainer/character menu"
	delete_button = $"HBoxContainer/delete button"

	# subscribe events
	character_menu.get_popup().connect("id_pressed", self, "on_character_selected")
	delete_button.connect("button_down", self, "on_delete_button_clicked")

	load_character_items_from_database()

func _exit_tree(): 
	character_menu.get_popup().disconnect("id_pressed", self, "on_character_selected")

func on_character_selected(id):
	var character_data = character_db.characters[id]
	character_menu.text = character_data.title
	character_menu.icon = null 

	character_id = character_data.id
	character_idx = id

	print("[Questie]: selected character: " + character_menu.text)

	# call event
	emit_signal("character_selected", character_id, character_idx)

func on_delete_button_clicked():
	print("[Questie]: part deletion requested...")
	emit_signal("deletion_request")

func load_character_items_from_database():
	var popup = character_menu.get_popup()

	# removes all previous items
	popup.clear()

	# generate items
	for character in character_db.characters:
		popup.add_item(character.title)

func autoload(character_name, id, idx):
	if character_name == "":
		character_menu.icon = default_icon
		character_menu.text = ""
		return

	character_menu.icon = null
	character_menu.text = character_name
	
	character_id = id
	character_idx = idx

