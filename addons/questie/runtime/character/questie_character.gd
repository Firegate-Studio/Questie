extends KinematicBody2D
class_name QuestieCharacter, "res://addons/questie/editor/icons/character_64x64.png"

export(GameCharacters.Characters) var character_type

# define if this character is the main character or not
export(bool) var is_player = false

# get the character identier as string
func get_id()->String:
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

# get all shop items data
func get_shop_data():
	
	# retrieve data from character database
	var data = get_data()
	if not data:
		print("[Questie]: Can not access shop data cause character data is invalid for character object:" + name)
		return

	# get shop items if is vendor
	if data.is_vendor: return data.shop

	print("[Questie]: this character is not vendor, ensure to have checked has shop in character editor")
	return null

# get all loot items
func get_loot_data():

	var data = get_data()
	if not data:
		print("[Questie]: Can not access shop data cause character data is invalid for charater object:" + name)
		return

	# get loot items
	if data.has_loot: return data.loot

	print("[Questie]: this character is not a lootable character/mob - ensure to have checked has_loot button in character editor")
	
