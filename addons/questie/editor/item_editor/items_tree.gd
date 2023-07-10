tool
extends Tree

signal new_item_created(item_id, data)
signal new_folder_created(folder_id, data)
signal new_tag_created(tag_id, data)
signal item_deleted(item_id)
signal folder_deleted(folder_id)
signal tag_deleted(tag_id)
signal item_renamed(item_id, new_name)
signal folder_renamed(folder_id, new_name)
signal tag_renamed(tag_id, new_name)

export var folder_icon : Texture
export var item_icon : Texture
export var tag_icon : Texture
export var delete_icon : Texture

var folders = {}
var items = {}
var tags = {}

var folder_data_class 
var item_data_class 

enum FolderProcedures{
	NEW_TAG,
	NEW_ITEM,
	DELETE
}

enum TagProcedures{
	NEW_ITEM, 
	DELETE
}

enum ItemProcedure{
	DELETE
}

func _enter_tree():
	var root = create_item()

	folder_data_class = preload("res://addons/questie/editor/item_editor/data/item_data.gd")
	item_data_class = preload("res://addons/questie/editor/item_editor/data/item_data.gd")

	connect("button_pressed", self, "handle_button_pressed")
	connect("item_edited", self, "handle_item_edited")

func _exit_tree():
	disconnect("button_pressed", self, "handle_button_pressed")
	disconnect("item_edited", self, "handle_item_edited")

func handle_button_pressed(item : TreeItem, column : int, id : int):
	# ensure to select the current item
	item.select(0)

	if is_folder(item):
		var data = get_folder_data(item)
		match id:
			FolderProcedures.NEW_TAG:
				create_new_tag(item, data.id)
			FolderProcedures.NEW_ITEM:
				create_new_item(item, data.id)
			FolderProcedures.DELETE:
				delete_folder(item)
	
	if is_tag(item):
		var data = get_tag_data(item)
		match id:
			TagProcedures.NEW_ITEM:
				create_new_item(item, "", data.id)
			TagProcedures.DELETE:
				delete_tag(item)

	if is_item(item):
		match id:
			ItemProcedure.DELETE:
				delete_item(item)
	
func handle_item_edited(): 
	var selected = get_selected()
	var changed = selected.get_text(0)

	if is_folder(selected):
		var id = get_folder_data(selected).id
		emit_signal("folder_renamed", id, changed)

	if is_tag(selected):
		var id = get_tag_data(selected).id
		emit_signal("tag_renamed", id, changed)

	if is_item(selected):
		var id = get_item_data(selected).id
		emit_signal("item_renamed", id, changed)

func create_new_item(parent = null, folder_id = "", tag_id = ""):

	# setup
	var new_item = create_item(parent)
	new_item.set_text(0,"New Item")
	new_item.set_editable(0, true)
	new_item.set_icon(0, item_icon)
	new_item.set_icon_max_width(0, 32)
	new_item.add_button(0, delete_icon)

	# generate data
	var data = item_data_class.new()
	data.id = UUID.generate()
	data.name = "New Item"
	data.folder_id = folder_id
	data.tag_id = tag_id

	# register new generated item
	items[new_item] = data

	# notify
	emit_signal("new_item_created", data.id, data)

func create_new_folder(parent = null):
	# setup
	var new_folder = create_item(parent)
	new_folder.set_text(0, "New Folder")
	new_folder.set_editable(0, true)
	new_folder.set_icon(0, folder_icon)
	new_folder.set_icon_max_width(0, 32)
	new_folder.add_button(0, tag_icon)
	new_folder.add_button(0, item_icon)
	new_folder.add_button(0, delete_icon)

	# generate data
	var data = folder_data_class.new()
	data.id = UUID.generate()
	data.name = "New Folder"

	# register new folder
	folders[new_folder] = data

	# notify
	emit_signal("new_folder_created", data.id, data)

func create_new_tag(parent = null, folder_id = ""):
	if not is_folder(parent): return
	
	# setup
	var new_tag = create_item(parent)
	new_tag.set_text(0, "New Tag")
	new_tag.set_editable(0, true)
	new_tag.set_icon(0, tag_icon)
	new_tag.set_icon_max_width(0, 32)
	new_tag.add_button(0, item_icon)
	new_tag.add_button(0, delete_icon)

	# generate data
	var data = folder_data_class.new()
	data.id = UUID.generate()
	data.name = "New Tag"
	data.folder_id = folder_id

	# register new tag
	tags[new_tag] = data

	# notify
	emit_signal("new_tag_created", data.id, data)

func is_folder(item : TreeItem): return folders.has(item)

func is_item(item : TreeItem): return items.has(item)

func is_tag(item : TreeItem): return tags.has(item)

func get_folder_data(item : TreeItem): return folders[item]

func get_item_data(item : TreeItem): return items[item]

func get_tag_data(item : TreeItem): return tags[item]

func delete_folder(item : TreeItem):
	# retrieve folder data
	var data = get_folder_data(item)
	if not data:
		print("[Questie]: can not retrieve folder data!")
		return

	# delete all tags
	for tag in tags.keys():
		var tag_data = get_tag_data(tag)
		if not tag_data.folder_id == data.id: continue

		delete_tag(tag)

	# destroy folder
	folders.erase(item)
	item.free()

	# notify
	emit_signal("folder_deleted", data.id)

func delete_tag(item : TreeItem):
	
	# retrieve tag data
	var data = get_tag_data(item)
	if not data:
		print("[Questie]: can't retrieve tag data!")
		return

	for item in items.keys():
		var item_data = get_item_data(item)
		if not item_data.tag_id == data.id: continue

		delete_item(item)

	tags.erase(item)
	item.free()

	# notify
	emit_signal("tag_deleted", data.id)

func delete_item(item : TreeItem):

	var id = get_item_data(item).id
	items.erase(item)
	item.free()

	# notify
	emit_signal("item_deleted", id)
