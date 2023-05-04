tool
extends Control

var new_character_btn : Button
var new_folder_btn : Button
var compile_btn : Button
var tree : Tree

func _enter_tree():
	new_character_btn = $"VBoxContainer/HBoxContainer/New Character Button"
	new_folder_btn = $"VBoxContainer/HBoxContainer/New Folder Button"
	compile_btn = $"VBoxContainer/HBoxContainer/Compile Button"
	tree = $VBoxContainer/HSplitContainer/Tree

	new_folder_btn.connect("button_down", self, "on_new_folder")
	new_character_btn.connect("button_down", self, "on_new_character")
	compile_btn.connect("button_down", self, "on_compile")

func on_new_folder(): 
	tree.create_folder_item()

func on_new_character(): 
	tree.create_character_item()

func on_compile(): pass
