tool 
extends Tree 
class_name QuestieFoldingTree

signal new_item_created(item, data)
signal new_folder_created(folder, data)
signal folder_deleted(folder_id)
signal item_deleted(item_id)

export var item_icon : Texture
export var folder_icon : Texture
export var trash_icon : Texture

var folders = {}
var items = {}

export var folder_data_class : Script = null
export var item_data_class : Script = null

enum FolderProcedures{
	NEW_ITEM,
	DELETE
}

enum ItemProcedures{
	DELETE
}

func _enter_tree():
	var root = create_item()
	connect("button_pressed", self, "handle_button_pressed")

func _exit_tree():
	disconnect("button_pressed", self, "handle_button_pressed")

func handle_button_pressed(item : TreeItem, column : int, id : int):
	
	item.select(0)

	#var selected_item = get_selected()
	#if item != selected_item: return

	if is_folder(item):
		match id:
			FolderProcedures.NEW_ITEM:
				create_new_item()
				item.deselect(0)
			FolderProcedures.DELETE:
				delete_folder(item)

	else:
		match id:
			ItemProcedures.DELETE:
				delete_item(item)


func create_new_item(name : String = "New Item", editable : bool = true, size : int = 32, has_delete_button : bool = true ):
	var new_item = null

	var selected_item = get_selected()

	if selected_item != null and not folders.has(selected_item): return

	# setup
	new_item = create_item(selected_item)
	new_item.set_text(0, name)
	new_item.set_editable(0, editable)
	new_item.set_icon(0, item_icon)
	new_item.set_icon_max_width(0, size)
	if has_delete_button: new_item.add_button(0, trash_icon)

	# generate item data
	var data = item_data_class.new()
	data.id = UUID.generate()
	if folders.has(selected_item): 
		data.category_id = folders[selected_item].id
	data.name = name
	
	# record new created item
	items[new_item] = data

	# notify
	emit_signal("new_item_created", new_item, data)

func create_new_folder(name : String = "New Folder", editable : bool = true, size : int = 32, has_item_button : bool = true, has_folder_button = false, has_delete_button = true ):
	var selected_item = get_selected()
	
	# setup
	var new_folder = create_item(selected_item)
	new_folder.set_text(0, name)
	new_folder.set_editable(0, editable)
	new_folder.set_icon(0, folder_icon)
	new_folder.set_icon_max_width(0, size)
	if has_folder_button: new_folder.add_button(0, folder_icon)
	if has_item_button: new_folder.add_button(0, item_icon)
	if has_delete_button: new_folder.add_button(0, trash_icon)

	# generate data
	var data = folder_data_class.new()
	data.id = UUID.generate()
	data.name = name

	# record new folder
	folders[new_folder] = data

	# notify
	emit_signal("new_folder_created", new_folder, data)

func delete_folder(folder : TreeItem):
	var data = get_folder_data(folder)
	if not data:
		print("[Questie]: can not retrieve folder data from QuestieTree")
		return

	var folder_id = data.id

	# remove sub items
	for item in items.keys():
		if not item.category_id == folder_id: continue

		var item_id = item.id
		items.erase(item)
		item.free()
		emit_signal("item_deleted", item_id)

	# remove target folder
	folders.erase(folder)
	folder.free()

	# notify
	emit_signal("folder_deleted", folder_id)    

func delete_item(item : TreeItem):
	var data = get_item_data(item)
	if not data:
		print("[Questie]: can not retrieve data from QuestieTree")
		return

	var item_id = data.id

	# delete target item
	items.erase(item)
	item.free()

	# notify
	emit_signal("item_deleted", item_id)

func is_folder(item : TreeItem)->bool:
	return folders.has(item)

func is_item(item : TreeItem)->bool:
	return items.has(item)

func get_folder_data(item : TreeItem):
	if not folders.has(item): return null
	return folders[item]

func get_item_data(item : TreeItem):
	if not items.has(item): return null
	return items[item]
