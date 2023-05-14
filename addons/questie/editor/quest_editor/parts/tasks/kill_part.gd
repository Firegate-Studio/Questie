tool
extends Panel

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

func _enter_tree():
    quantity = $HBoxContainer/quantity
    character = $HBoxContainer/character
    delete_btn = $HBoxContainer/delete




    