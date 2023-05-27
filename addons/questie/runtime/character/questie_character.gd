extends KinematicBody2D
class_name QuestieCharacter, "res://addons/questie/editor/icons/character_64x64.png"

export(GameCharacters.Characters) var character_type

# define if this character is the main character or not
export(bool) var is_player = false

func _enter_tree():
	property_list_changed_notify()
	print("enter character: " + var2str(character_type))

func _init():
	print("init character: " + var2str(character_type))

# get the character identier as string
func get_id()->String:
	print("character: " + var2str(character_type))
	return GameCharacters.characters_map[character_type]

# try to get character data - if none is found returns NULL
func get_data():

	# load the characters database
	var database = load("res://questie/characters-db.tres")

	# setup id
	var identifier = get_id()

	for character in database.characters:
		if not character.id == identifier: continue
		
		return character

	return null

