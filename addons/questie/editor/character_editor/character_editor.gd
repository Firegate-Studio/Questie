tool
extends Control

var new_character_btn : Button
var new_folder_btn : Button
var compile_btn : Button
var tree : Tree
var workspace

func _enter_tree():
	new_character_btn = $"VBoxContainer/HBoxContainer/New Character Button"
	new_folder_btn = $"VBoxContainer/HBoxContainer/New Folder Button"
	compile_btn = $"VBoxContainer/HBoxContainer/Compile Button"
	tree = $VBoxContainer/HSplitContainer/Tree
	workspace = $"VBoxContainer/HSplitContainer/Character Workspace/Character Slot"

	new_folder_btn.connect("button_down", self, "on_new_folder")
	new_character_btn.connect("button_down", self, "on_new_character")
	compile_btn.connect("button_down", self, "on_compile")
	tree.connect("character_selected", self, "on_character_selected")
	tree.connect("character_deleted", self, "on_character_deleted")

func on_new_folder(): 
	tree.create_folder_item()

func on_new_character(): 
	tree.create_character_item()

func on_compile(): pass

func on_character_selected(character_id):
	workspace.setup(character_id)
	workspace.show()

func on_character_deleted(character_id):

	if not character_id == workspace.id: return
	workspace.hide()
