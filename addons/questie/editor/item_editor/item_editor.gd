tool
extends Control

var new_folder_btn : Button
var compile_btn : Button
var tree 
var editor
var empty_space
var database = preload("res://questie/item-db.tres")
const DB_PATH = "res://questie/item-db.tres"

func _enter_tree():
	new_folder_btn = $"VBoxContainer/HBoxContainer/New Folder"
	compile_btn = $VBoxContainer/HBoxContainer/Compile
	tree = $VBoxContainer/HSplitContainer/Tree
	editor = $"VBoxContainer/HSplitContainer/Item Edit"
	empty_space = $VBoxContainer/HSplitContainer/Empty

	# subscibe events
	new_folder_btn.connect("button_down", self, "on_new_folder_button_clicked")
	compile_btn.connect("button_down", self, "on_compile_button_clicked")
	tree.connect("object_selected", self, "handle_tree_object_selected")

	tree.connect("new_folder_created", self, "handle_new_folder_created")
	tree.connect("new_tag_created", self, "handle_new_tag_created")
	tree.connect("new_item_created", self, "handle_new_item_created")

	tree.connect("folder_renamed", self, "handle_folder_renamed")
	tree.connect("tag_renamed", self, "handle_tag_renamed")
	tree.connect("item_renamed", self, "handle_item_renamed")

	tree.connect("folder_deleted", self, "handle_folder_deleted")
	tree.connect("tag_deleted", self, "handle_tag_deleted")
	tree.connect("item_deleted", self, "handle_item_deleted")

func _ready():
	load_tree_items()

func _exit_tree():
	new_folder_btn.disconnect("button_down", self, "on_new_folder_button_clicked")
	compile_btn.disconnect("button_down", self, "on_compile_button_clicked")

	tree.disconnect("new_folder_created", self, "handle_new_folder_created")
	tree.disconnect("new_tag_created", self, "handle_new_tag_created")
	tree.disconnect("new_item_created", self, "handle_new_item_created")

	tree.disconnect("folder_renamed", self, "handle_folder_renamed")
	tree.disconnect("tag_renamed", self, "handle_tag_renamed")
	tree.disconnect("item_renamed", self, "handle_item_renamed")

	tree.disconnect("folder_deleted", self, "handle_folder_deleted")
	tree.disconnect("tag_deleted", self, "handle_tag_deleted")
	tree.disconnect("item_deleted", self, "handle_item_deleted")

func on_new_folder_button_clicked():
	tree.create_new_folder()

func on_compile_button_clicked():
	print("[Questie]: compile all items")
	ItemsFileBuilder.compile()

func handle_tree_object_selected(id):
	var data = database.get_item(id)
	if not data:
		print("[Questie]: can't retrieve item data from database")
		return
		
	empty_space.hide()
	editor.show()
	editor.setup(data.id)
	
func handle_new_folder_created(folder_id, data):
	database.push_category(data)
	ResourceSaver.save(DB_PATH, database)

func handle_new_tag_created(id, data):
	database.push_tag(data)
	ResourceSaver.save(DB_PATH, database)

func handle_new_item_created(id, data):
	database.push_item(data)
	ResourceSaver.save(DB_PATH, database)

func handle_folder_renamed(id, text):
	var index = database.get_category_index(id)
	if not index > -1:
		print("[Questie]: category not found in item database!")
		return
	
	database.categories[index].name = text
	ResourceSaver.save(DB_PATH, database)

func handle_tag_renamed(id, text):
	var data = database.get_tag(id)
	data.name = text
	ResourceSaver.save(DB_PATH, database)

func handle_item_renamed(id, text):
	var data = database.get_item(id)
	data.name = text
	ResourceSaver.save(DB_PATH, database)

func handle_folder_deleted(id):
	database.erase_category(id)
	ResourceSaver.save(DB_PATH, database)
	swap_screens()

func handle_tag_deleted(id):
	database.erase_tag(id)
	ResourceSaver.save(DB_PATH, database)
	swap_screens()

func handle_item_deleted(id):
	database.erase_item(id)
	ResourceSaver.save(DB_PATH, database)
	swap_screens()

# @brief loads all folders, tags and items from the items datatabase
func load_tree_items():

	# load folders
	for folder in database.categories:
		tree.load_folder(folder)
	
	# load tags
	for tag in database.tags:
		tree.load_tag(tag)

	# load items
	for item in database.items:
		tree.load_item(item)

func swap_screens():
	editor.hide()
	empty_space.show()
