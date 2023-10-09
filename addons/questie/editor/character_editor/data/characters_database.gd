tool
extends Resource
class_name CharacterDatabase

# database identifier
var id : UUID

export(Array) var folders = []

export(Array) var characters = []

func add_folder(folder_data):
	folders.push_back(folder_data)

func remove_folder(id):
	for folder in folders:
		if not folder.id == id: continue
		
		folders.erase(folder)
		break

func get_folder_data(id):
	for folder in folders:
		if not folder.id == id: continue
		
		return folder

	return null

func add_character(character_data):
	characters.push_back(character_data)

func remove_character(character_id):
	for character in characters:
		if not character.id == character_id: continue

		characters.erase(character)
		break

func get_character_data(character_id):
	for character in characters:
		if not character.id == character_id: continue

		return character
	return null

