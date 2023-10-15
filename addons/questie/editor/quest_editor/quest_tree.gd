tool
extends Tree

# @brief					called when the quest item is pressed
# @param quest_id			the identifier of the quest inside the quest database
signal quest_item_pressed(quest_id)

# @brief					called when a chain item is pressed
# @param chain_id			the identifier of the chain inside the chain database
signal chain_item_pressed(chain_id)

# The master root branch for tree view
var root : TreeItem

var quest_database : QuestDatabase = preload("res://questie/quest-db.tres")
var chain_database : ChainDatabase = null

export(Texture) var folder_icon
export(Texture) var quest_icon
export(Texture) var delete_icon
export(Texture) var chain_icon

# tree item containers to store generated items (quests or folders) - can be used to get the ID from the associated map
var folders : Array
var quests : Array
var chains : Array

# identifiers map to store the generated or loaded identifiers pointing to data to get
var folders_id_map = {}
var quests_id_map = {}
var chains_id_map = {}

enum FolderProcedure{NewFolder, NewQuest, NewChain, Delete}
enum QuestProcedure{Delete}
enum ChainProcedure{Delete}

func _enter_tree(): 

	chain_database = ResourceLoader.load("res://questie/chain-db.tres")
	if not chain_database:
		print("[Questie]: chain database has not been found!")
		return

	root = create_item()
	hide_root = true

	load_saves()

	connect("button_pressed", self, "on_button_pressed")
	connect("item_edited", self, "on_item_edited")
	connect("cell_selected", self, "on_item_selected")

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

			FolderProcedure.NewChain:
				create_sub_chain(get_selected(), "New Chain")
				return

			FolderProcedure.Delete:
				remove_folder_recursive(get_selected())
				return

	if quests.has(get_selected()):
		match id:
			QuestProcedure.Delete:
				remove_quest(get_selected())
				return

	if chains.has(get_selected()):
		match id:
			ChainProcedure.Delete:
				remove_chain(get_selected())
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

	if is_chain(selected):
		var id = chains_id_map[selected]
		var data = chain_database.get_chain_data(id)
		if not data:
			print("[Questie]: can't retireve data for chain " + id)
			return

		data.name = selected.get_text(0)
		ResourceSaver.save("res://questie/chain-db.tres", chain_database)
		print("[Questie]: set text to " +data.name + " for quest " + id)
		return

func on_item_selected():
	var selected = get_selected()
	
	if is_quest(selected):
		var quest_id = quests_id_map[selected]
		emit_signal("quest_item_pressed", quest_id)
	
	if is_chain(selected):
		var chain_id = chains_id_map[selected]
		emit_signal("chain_item_pressed", chain_id)

func create_folder(folder_name : String):
	var folder = create_item(root)
	folder.set_text(0, folder_name)
	folder.set_editable(0, true)
	folder.set_icon(0, folder_icon)
	folder.set_icon_max_width(0, 32)
	folder.set_custom_as_button(0, true)
	folder.add_button(0, folder_icon)
	folder.add_button(0, quest_icon)
	folder.add_button(0, chain_icon)
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
	folder.add_button(0, chain_icon)
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

func create_chain(chain_name : String):
	var chain = create_item()
	chain.set_text(0, chain_name)
	chain.set_editable(0, true)
	chain.set_icon(0, chain_icon)
	chain.set_icon_max_width(0, 32)
	chain.set_custom_as_button(0, true)
	chain.add_button(0, delete_icon)

	var data = ChainData.new()
	data.id = UUID.generate()
	data.name = chain_name
	chain_database.add_chain_data(data)
	ResourceSaver.save("res://questie/chain-db.tres", chain_database)

	chains.append(chain)
	chains_id_map[chain] = data.id

func create_sub_chain(parent : TreeItem, chain_name : String):
	var chain = create_item(parent)
	chain.set_text(0, chain_name)
	chain.set_editable(0, true)
	chain.set_icon(0, chain_icon)
	chain.set_icon_max_width(0, 32)
	chain.set_custom_as_button(0, true)
	chain.add_button(0, delete_icon)

	var data = ChainData.new()
	data.id = UUID.generate()
	data.name = chain_name
	data.parent_id = folders_id_map[parent]
	chain_database.add_chain_data(data)
	ResourceSaver.save("res://questie/chain-db.tres", chain_database)

	chains.append(chain)
	chains_id_map[chain] = data.id

func remove_quest(quest : TreeItem):
	var id = quests_id_map[quest]
	quest_database.erase_quest(id)
	quests.erase(quest)
	quests_id_map.erase(quest)
	quest.free()
	ResourceSaver.save("res://questie/quest-db.tres", quest_database)

func remove_chain(chain : TreeItem):
	var id = chains_id_map[chain]
	chain_database.remove_chain_data(id)
	chains.erase(chain)
	chains_id_map.erase(chain)
	chain.free()
	ResourceSaver.save("res://questie/chain-db.tres", chain_database)

func remove_folder_recursive(folder_item : TreeItem):
	var id = folders_id_map[folder_item]
	var folder_deletion_queue = []
	var quest_deletion_queue = []
	var chain_deletion_queue = []
	
	var children = get_all_children(folder_item)
	for child in children:
		print(child.get_text(0))

		if is_quest(child):
			quest_deletion_queue.append(child)
			continue

		if is_folder(child):
			folder_deletion_queue.append(child)
			continue

		if is_chain(child):
			chain_deletion_queue.append(child)
			continue

	# remove quests
	for quest_item in quest_deletion_queue:
		remove_quest(quest_item)

	for chain_item in chain_deletion_queue:
		remove_chain(chain_item)

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

func is_chain(item : TreeItem)->bool: return chains.has(item)

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
		item.add_button(0, chain_icon)
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

	for chain in chain_database.chains:
		if not chain.parent_id == "": continue

		var item = create_item(root)
		item.set_text(0, chain.name)
		item.set_editable(0, true)
		item.set_icon(0, chain_icon)
		item.set_icon_max_width(0, 32)
		item.set_custom_as_button(0, true)
		item.add_button(0, delete_icon)

		chains.append(item)
		chains_id_map[item] = chain.id

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
		item.add_button(0, chain_icon)
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

	# load all sub-chains
	for chain in chain_database.chains:
		if chain.parent_id == "": continue

			# find parent folder
		var parent : TreeItem = null
		for item in folders:
			if not folders_id_map[item] == chain.parent_id: continue 

			parent = item
			break

		if not parent:
			print("[Questie]: parent was not found for quest " + chain.id)
			return

		var item = create_item(parent)
		item.set_text(0, chain.name)
		item.set_editable(0, true)
		item.set_icon(0, chain_icon)
		item.set_icon_max_width(0, 32)
		item.set_custom_as_button(0, true)
		item.add_button(0, delete_icon)

		chains.append(item)
		chains_id_map[item] = chain.id

		
