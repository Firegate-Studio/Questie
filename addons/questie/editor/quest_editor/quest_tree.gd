tool
extends Tree

# The master root branch for tree view
var root : TreeItem

var quest_database : QuestDatabase = preload("res://questie/quest-db.tres")

export(Texture) var folder_icon
export(Texture) var quest_icon
export(Texture) var delete_icon

# tree item containers to store generated items (quests or folders) - can be used to get the ID from the associated map
var folders : Array
var quests : Array

# identifiers map to store the generated or loaded identifiers pointing to data to get
var folders_id_map = {}
var quests_id_map = {}

enum FolderProcedure{NewFolder, NewQuest, Delete}
enum QuestProcedure{Delete}

func _enter_tree(): 
	root = create_item()
	hide_root = true

	load_saves()

	connect("button_pressed", self, "on_button_pressed")
	connect("item_edited", self, "on_item_edited")

func _exit_tree(): pass

func on_button_pressed(item : TreeItem, column : int, id : int):
	#var selected_item = get_selected()

	#if not selected_item == item:
	item.select(0)

	if folders.has(get_selected()): 		
		match id:
			FolderProcedure.NewFolder:
				create_sub_folder(get_selected(), "New Folder")
				return
			FolderProcedure.NewQuest:
				create_sub_quest(get_selected(), "New Quest")	
				return
			FolderProcedure.Delete:
				remove_folder_recursive(get_selected())
				return

	if quests.has(get_selected()):
		match id:
			QuestProcedure.Delete:
				remove_quest(get_selected())
				return

func on_item_edited():
	var selected = get_selected()
	
	if is_folder(selected):
		var id = folders_id_map[selected]
		var data = quest_database.get_folder_data(id)
		if not data:
			print("[Questie]: can not retrieve folder data for folder " + id)
			return
		
		data.name = selected.get_text(0)
		ResourceSaver.save("res://questie/quest-db.tres", quest_database)
		print("[Questie]: set text to " + data.name + " for folder " + id)

		return

	if is_quest(selected):
		var id = quests_id_map[selected]
		var data = quest_database.get_quest_data(id)
		if not data:
			print("[Questie]: can not retrieve data for quest " + id)
			return

		data.item_name = selected.get_text(0)
		ResourceSaver.save("res://questie/quest-db.tres", quest_database)
		print("[Questie]: set text to " + data.item_name + " for quest " + id)

		return


func create_folder(folder_name : String):
	var folder = create_item(root)
	folder.set_text(0, folder_name)
	folder.set_editable(0, true)
	folder.set_icon(0, folder_icon)
	folder.set_icon_max_width(0, 32)
	folder.set_custom_as_button(0, true)
	folder.add_button(0, folder_icon)
	folder.add_button(0, quest_icon)
	folder.add_button(0, delete_icon)

	var data = load("res://addons/questie/editor/quest_editor/data/folder_data.gd").new()
	data.id = UUID.generate()
	data.name = folder_name
	quest_database.push_folder(data)
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

	folders.append(folder)
	folders_id_map[folder] = data.id

func create_sub_folder(parent : TreeItem, folder_name):
	if not folders.has(parent):
		return

	var folder = create_item(parent)
	folder.set_text(0, folder_name)
	folder.set_editable(0, true)
	folder.set_icon(0, folder_icon)
	folder.set_icon_max_width(0, 32)
	folder.set_custom_as_button(0, true)
	folder.add_button(0, folder_icon)
	folder.add_button(0, quest_icon)
	folder.add_button(0, delete_icon)

	var data = load("res://addons/questie/editor/quest_editor/data/folder_data.gd").new()
	data.id = UUID.generate()
	data.parent_id = folders_id_map[parent]
	data.name = folder_name
	quest_database.push_folder(data)
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

	folders.append(folder)
	folders_id_map[folder] = data.id	

func create_quest(quest_name : String):
	var quest = create_item()
	quest.set_text(0, quest_name)
	quest.set_editable(0, true)
	quest.set_icon(0, quest_icon)
	quest.set_icon_max_width(0, 32)
	quest.set_custom_as_button(0, true)
	quest.add_button(0, delete_icon)

	var data : QuestData = QuestData.new()
	data.id = UUID.generate()
	data.item_name = quest_name
	quest_database.push_new_quest(data)
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

	quests.append(quest)
	quests_id_map[quest] = data.id

func create_sub_quest(parent : TreeItem, quest_name : String):
	if not folders.has(parent): return

	var quest = create_item(parent)
	quest.set_text(0, quest_name)
	quest.set_editable(0, true)
	quest.set_icon(0, quest_icon)
	quest.set_icon_max_width(0, 32)
	quest.set_custom_as_button(0, true)
	quest.add_button(0, delete_icon)

	var data : QuestData = QuestData.new()
	data.id = UUID.generate()
	data.item_name = quest_name
	data.parent_folder_id = folders_id_map[parent]
	quest_database.push_new_quest(data)
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

	quests.append(quest)
	quests_id_map[quest] = data.id

func remove_quest(quest : TreeItem):
	var id = quests_id_map[quest]
	quest_database.erase_quest(id)
	quests.erase(quest)
	quests_id_map.erase(quest)
	quest.free()
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func remove_folder_recursive(folder_item : TreeItem):
	var id = folders_id_map[folder_item]
	var folder_deletion_queue = []
	var quest_deletion_queue = []
	
	var children = get_all_children(folder_item)
	for child in children:
		print(child.get_text(0))

		if is_quest(child):
			quest_deletion_queue.append(child)
			continue

		if is_folder(child):
			folder_deletion_queue.append(child)
			continue

	# remove quests
	for quest_item in quest_deletion_queue:
		remove_quest(quest_item)

	# remove folders
	for folder in folder_deletion_queue:
		remove_folder_single(folder)

	remove_folder_single(folder_item)
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func remove_folder_single(folder_item : TreeItem):
	var folder_id = folders_id_map[folder_item]
	quest_database.erase_folder(folder_id)
	folders.erase(folder_item)
	folders_id_map.erase(folder_item)
	folder_item.free()
	print("[Questie]: removed folder " + folder_id)

func get_all_children(tree_item : TreeItem):
	var children = []

	var child = tree_item.get_children()

	while not child == null:
		children.append(child)
		
		var sub_children = get_all_children(child)
		for sub_child in sub_children:
			children.append(sub_child)

		child = child.get_next()

	return children	

func is_folder(item : TreeItem)->bool: return folders.has(item)

func is_quest(item : TreeItem)->bool: return quests.has(item)

# load all the stored data inside the tree item
func load_saves():

	# load all root folders
	for folder in quest_database.folders:
		if not folder.parent_id == "": continue
		
		var item = create_item(root)
		item.set_text(0, folder.name)
		item.set_editable(0, true)
		item.set_icon(0, folder_icon)
		item.set_icon_max_width(0, 32)
		item.set_custom_as_button(0, true)
		item.add_button(0, folder_icon)
		item.add_button(0, quest_icon)
		item.add_button(0, delete_icon)

		folders.append(item)
		folders_id_map[item] = folder.id

	# load all root quests
	for quest in quest_database.quests:
		if not quest.parent_folder_id == "": continue

		var item = create_item(root)
		item.set_text(0, quest.item_name)
		item.set_editable(0, true)
		item.set_icon(0, quest_icon)
		item.set_icon_max_width(0, 32)
		item.set_custom_as_button(0, true)
		item.add_button(0, delete_icon)

		quests.append(item)
		quests_id_map[item] = quest.id

	# load all sub-folders
	for folder in quest_database.folders:
		if folder.parent_id == "": continue

		# find parent folder
		var parent : TreeItem = null
		for item in folders:
			if not folders_id_map[item] == folder.parent_id: continue 

			parent = item
			break

		if not parent:
			print("[Questie]: parent was not found for folder " + folder.id)
			return

		var item = create_item(parent)
		item.set_text(0, folder.name)
		item.set_editable(0, true)
		item.set_icon(0, folder_icon)
		item.set_icon_max_width(0, 32)
		item.set_custom_as_button(0, true)
		item.add_button(0, folder_icon)
		item.add_button(0, quest_icon)
		item.add_button(0, delete_icon)

		folders.append(item)
		folders_id_map[item] = folder.id

	# load all sub-quests
	for quest in quest_database.quests:
		if quest.parent_folder_id == "": continue

		# find parent folder
		var parent : TreeItem = null
		for item in folders:
			if not folders_id_map[item] == quest.parent_folder_id: continue 

			parent = item
			break

		if not parent:
			print("[Questie]: parent was not found for quest " + quest.id)
			return

		var item = create_item(parent)
		item.set_text(0, quest.item_name)
		item.set_editable(0, true)
		item.set_icon(0, quest_icon)
		item.set_icon_max_width(0, 32)
		item.set_custom_as_button(0, true)
		item.add_button(0, delete_icon)

		quests.append(item)
		quests_id_map[item] = quest.id

		
