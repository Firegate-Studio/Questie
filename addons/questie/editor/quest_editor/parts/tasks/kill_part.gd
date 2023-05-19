tool
extends Panel

signal quantity_changed(value)
signal character_selected(character_id, character_index)
signal deletion_request()

var quantity : SpinBox
var character : MenuButton
var delete_btn : Button

# the number of characters to kill
var kills_count : int = 1

# the index of the characters to kill
var character_index : int = -1

# the character identifier of the character to kill
var character_id : String = ""

# the characters database
var characters_db = preload("res://questie/characters-db.tres")

var character_icon = preload("res://addons/questie/editor/icons/character_32x32.png")

func _enter_tree():
	quantity = $HBoxContainer/quantity
	character = $HBoxContainer/character
	delete_btn = $HBoxContainer/delete

	quantity.connect("value_changed", self, "on_quantity_changed")
	character.get_popup().connect("id_pressed", self, "on_character_selected")
	delete_btn.connect("button_down", self, "on_deletion_request")

	load_characters_from_database()

func _exit_tree():
	quantity.disconnect("value_changed", self, "on_quantity_changed")
	character.get_popup().disconnect("id_pressed", self, "on_character_selected")
	delete_btn.disconnect("button_down", self, "on_deletion_request")

func on_quantity_changed(value):
	print("[Questie]: set quantity to " + var2str(value))
	kills_count = value
	emit_signal("quantity_changed", value)

func on_character_selected(id):
	var database = preload("res://questie/characters-db.tres")
	var data = database.characters[id]
	if not data:
		print("[Questie]: can not retireve character data from database for kill_task_part.gd")
		return

	character_id = data.id
	character_index = id

	# update viewport
	character.text = data.title

	# log
	print("[Questie]: set character to kill to " + data.title)

	# call event
	emit_signal("character_selected", character_id, character_index)

func on_deletion_request():
	print("[Questie]: kill task part deletion requested...")
	emit_signal("deletion_request")


func load_characters_from_database():
	# get characters database
	var database = load("res://questie/characters-db.tres")

	var popup = character.get_popup()

	# clean listed items
	popup.clear()

	# load items
	for data in database.characters:
		popup.add_icon_item(character_icon, data.title)

func autoload(task_data):
	# retrieve characters database
	var database = load("res://questie/characters-db.tres")

	load_characters_from_database()

	# pass information
	quantity.value = task_data.target_kills
	character_id = task_data.character_id
	character_index = task_data.character_index

	# update interface
	if character_index == -1: 
		character.text = "Select Character"
	else:
		character.text = database.characters[character_index].title



	
