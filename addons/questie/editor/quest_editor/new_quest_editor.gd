tool
extends Control

var new_folder_button : ToolButton
var new_quest_button : ToolButton
var compile_button : ToolButton

var quest_tree 

func _enter_tree(): 
	
	quest_tree = $VBoxContainer/HSplitContainer/Tree

	# buttons
	new_folder_button = $VBoxContainer/HBoxContainer/NewFolderButton
	new_quest_button = $VBoxContainer/HBoxContainer/NewQuestButton
	compile_button = $VBoxContainer/HBoxContainer/CompileButton

	new_folder_button.connect("button_down", self, "on_new_folder_button_pressed")
	new_quest_button.connect("button_down", self, "on_new_quest_button_pressed")
	compile_button.connect("button_down", self, "on_compile_button_pressed")

func _exit_tree():

	new_folder_button.disconnect("button_down", self, "on_new_folder_button_pressed")
	new_quest_button.disconnect("button_down", self, "on_new_quest_button_pressed")
	compile_button.disconnect("button_down", self, "on_compile_button_pressed")

func on_new_folder_button_pressed(): 
	quest_tree.create_folder("New Folder")

func on_new_quest_button_pressed():
	quest_tree.create_quest("New Quest")

