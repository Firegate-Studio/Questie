tool
extends Tree

signal character_deleted(character_id)
signal folder_deleted(folder_id)
signal folder_selected(folder_id)
signal character_selected(character_id)

var root
var folders = {}
var characters = {}

var database = preload("res://questie/characters-db.tres")

enum FolderProcedure{
	NEW_FOLDER = 0,
	NEW_CHARACTER = 1,
	DELETE = 2
}

enum CharacterProcedures{
	DELETE
}

func _enter_tree():
	root = create_item()
	root.set_text(0, "Characters")
	root.set_custom_as_button(0, true)

	load_folders()
	load_characters()

	connect("item_edited", self, "on_item_edited")
	connect("button_pressed", self, "on_button_pressed")
	connect("item_selected", self, "on_item_selected")

func on_item_edited():
	var selected_item = get_selected()
	if not selected_item:
		print("[Questie]: selected item is invalid!")
		return
	
	print("[Questie]: set text to " + selected_item.get_text(0))

	if is_folder(selected_item): 
		var data = database.get_folder_data(folders[selected_item])
		data.name = selected_item.get_text(0)
		ResourceSaver.save("res://questie/characters-db.tres", database)
		return

	if is_character(selected_item):
		var data = database.get_character_data(characters[selected_item])
		data.title = selected_item.get_text(0)
		ResourceSaver.save("res://questie/characters-db.tres", database)
		return

func on_button_pressed(item, column, id):

	item.select(column)

	print(id)
	if is_folder(item):
		match id:
			FolderProcedure.NEW_FOLDER:
				create_subfolder_item()
			FolderProcedure.NEW_CHARACTER:
				create_subcharacter_item()
			FolderProcedure.DELETE:
				# get folder identifier
				var identifier = folders[item]
				if identifier == "":
					print("[Questie]: can not retrieve folder identifier")
					return
				
				# record all folder to destroy
				var folder_items = []
				var folders_id = []

				for folder in database.folders:
					if not folder.parent == identifier: continue

					for key in folders.keys():
						if not folders[key] == folder.id: continue
						folder_items.push_back(key)
						break

					folders_id.push_back(folder.id)

				folder_items.push_back(item)
				folders_id.push_back(identifier)

				# record all characters to destroy
				var char_items = []
				var chars_id = []
				for character in database.characters:
					if not folders_id.has(character.parent): continue
					
					for key in characters.keys():
						if not characters[key] == character.id: continue
						char_items.push_back(key)
						break
					
					chars_id.push_back(character.id)

				# remove all child characters
				for id in chars_id:
					database.remove_character(id)
					characters.erase(id)
					emit_signal("character_deleted", id)

				for item in char_items:
					item.free()

				# remove all child folders
				for id in folders_id:
					database.remove_folder(id)
					folders.erase(id)
					emit_signal("folder_deleted", id)

				for item in folder_items:
					item.free()

				ResourceSaver.save("res://questie/characters-db.tres", database)
				
		return

	if is_character(item): 
		match id:
			CharacterProcedures.DELETE:
				
				# get character id
				var identifier = characters[item]
				if identifier == "":
					print("[Questie]: can not find character id")
					return

				database.remove_character(identifier)
				ResourceSaver.save("res://questie/characters-db.tres", database)
				characters.erase(item)
				item.free()

				emit_signal("character_deleted", identifier)
		return

func on_item_selected(): 
	var selected_item = get_selected()
	if not selected_item:
		print("[Questie]: invalid selected item")
		return
	
	var identifier = ""
	if is_folder(selected_item): 
		identifier = folders[selected_item]
		emit_signal("folder_selected", identifier)
	
	if is_character(selected_item): 
		identifier = characters[selected_item]
		emit_signal("character_selected", identifier)

	print("[Questie]: selected item " + identifier)


func create_folder_item(): 

	var folder = create_item()
	if not folder:
		print("[Questie]: can not create folder item!")
		return
		
	folder.set_text(0, "NewFolder")
	folder.set_editable(0, true)
	folder.set_expand_right(0, true)
	folder.set_icon(0, load("res://addons/questie/editor/icons/folder.png"))
	folder.set_icon_max_width(0, 32)
	folder.add_button(0, load("res://addons/questie/editor/icons/folder_32x32.png"))
	folder.add_button(0, load("res://addons/questie/editor/icons/character_32x32.png"))
	folder.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))

	# generate folder data
	var data = load("res://addons/questie/editor/character_editor/data/folder.gd").new()
	var identifier = UUID.generate()
	data.id = identifier
	data.name = "NewFolder"
	database.add_folder(data)
	folders[folder] = identifier
	ResourceSaver.save("res://questie/characters-db.tres", database)

func create_subfolder_item(): 
	var selected_item = get_selected()

	var folder = create_item(selected_item)
	folder.set_text(0, "NewFolder")
	folder.set_editable(0, true)
	folder.set_expand_right(0, true)
	folder.set_icon(0, load("res://addons/questie/editor/icons/folder.png"))
	folder.set_icon_max_width(0, 32)
	folder.add_button(0, load("res://addons/questie/editor/icons/folder_32x32.png"))
	folder.add_button(0, load("res://addons/questie/editor/icons/character_32x32.png"))
	folder.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))

	# generate folder data
	var data = load("res://addons/questie/editor/character_editor/data/folder.gd").new()
	var identifier = UUID.generate()
	data.id = identifier
	data.parent = folders[selected_item]
	data.name = "NewFolder"
	database.add_folder(data)
	folders[folder] = identifier
	ResourceSaver.save("res://questie/characters-db.tres", database)

func create_character_item(): 
	var item = create_item()
	if not item:
		print("[Questie]: can not create folder item!")
		return
		
	item.set_text(0, "NewCharacter")
	item.set_editable(0, true)
	item.set_expand_right(0, true)
	item.set_icon(0, load("res://addons/questie/editor/icons/character_32x32.png"))
	item.set_icon_max_width(0, 32)
	item.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))

	# generate character data
	var data = load("res://addons/questie/editor/character_editor/data/character.gd").new()
	var identifier = UUID.generate()
	data.id = identifier
	data.title = "NewCharacter"
	database.add_character(data)
	characters[item] = identifier
	ResourceSaver.save("res://questie/characters-db.tres", database)

func create_subcharacter_item():
	var selected_item = get_selected()

	var item = create_item(selected_item)
	if not item:
		print("[Questie]: can not create folder item!")
		return
		
	item.set_text(0, "NewCharacter")
	item.set_editable(0, true)
	item.set_expand_right(0, true)
	item.set_icon(0, load("res://addons/questie/editor/icons/character_32x32.png"))
	item.set_icon_max_width(0, 32)
	item.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))

	# generate character data
	var data = load("res://addons/questie/editor/character_editor/data/character.gd").new()
	var identifier = UUID.generate()
	data.id = identifier
	data.title = "NewCharacter"
	data.parent = folders[selected_item]
	database.add_character(data)
	characters[item] = identifier
	ResourceSaver.save("res://questie/characters-db.tres", database)

func is_folder(item) -> bool:
	return folders.has(item)

func is_character(tree_item):
	return characters.has(tree_item)

func load_folders():
	
	# generate main folders	
	for folder in database.folders:

		if not folder.parent == "": continue

		var item = create_item()
		item.set_text(0, folder.name)
		item.set_editable(0, true)
		item.set_icon(0, load("res://addons/questie/editor/icons/folder.png"))
		item.set_icon_max_width(0, 32)
		item.set_custom_as_button(0, true)
		item.add_button(0, load("res://addons/questie/editor/icons/folder_32x32.png"))
		item.add_button(0, load("res://addons/questie/editor/icons/character_32x32.png"))
		item.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))

		folders[item] = folder.id

	# generate sub-folders
	for folder in database.folders:
		if folder.parent == "": continue
		
		# get parent folder
		var parent
		for key in folders.keys():
			if not folders.has(key): continue
			if not folder.parent == folders[key]: continue
			
			parent = key
			break

		var item = create_item(parent)
		item.set_text(0, folder.name)
		item.set_editable(0, true)
		item.set_icon(0, load("res://addons/questie/editor/icons/folder.png"))
		item.set_icon_max_width(0, 32)
		item.set_custom_as_button(0, true)
		item.add_button(0, load("res://addons/questie/editor/icons/folder_32x32.png"))
		item.add_button(0, load("res://addons/questie/editor/icons/character_32x32.png"))
		item.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))

		folders[item] = folder.id
		
func load_characters():

	# load root characters
	for character in database.characters:
		if not character.parent == "": continue
		
		var item = create_item()
		item.set_text(0, character.title)
		item.set_editable(0, true)
		item.set_expand_right(0, true)
		item.set_icon(0, load("res://addons/questie/editor/icons/character_32x32.png"))
		item.set_icon_max_width(0, 32)
		item.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))	
		characters[item] = character.id

	# load sub-characters
	for character in database.characters:
		if character.parent == "": continue
		
		# get parent folder
		var parent
		for key in folders.keys():
			if not folders[key] == character.parent: continue

			parent = key
			break
		
		var item = create_item(parent)
		item.set_text(0, character.name)
		item.set_editable(0, true)
		item.set_expand_right(0, true)
		item.set_icon(0, load("res://addons/questie/editor/icons/character_32x32.png"))
		item.set_icon_max_width(0, 32)
		item.add_button(0, load("res://addons/questie/editor/icons/trash_32x32.png"))	
		characters[item] = character.id






		

		
