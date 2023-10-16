tool
extends Control

var new_folder_button : ToolButton
var new_quest_button : ToolButton
var new_chain_button : ToolButton
var compile_button : ToolButton

var quest_builder_graph : QuestDesignerGraph
var quest_chain_graph : QuestChainGraph

var quest_tree 

func _enter_tree(): 
	
	quest_tree = $VBoxContainer/HSplitContainer/VSplitContainer/QuestTree
	quest_builder_graph = $VBoxContainer/HSplitContainer/VBoxContainer/QuestBuilderView
	quest_chain_graph = $"VBoxContainer/HSplitContainer/VBoxContainer/QuestChainView"

	new_folder_button = $VBoxContainer/HBoxContainer/NewFolderButton
	new_quest_button = $VBoxContainer/HBoxContainer/NewQuestButton
	new_chain_button = $VBoxContainer/HBoxContainer/NewChainButton
	compile_button = $VBoxContainer/HBoxContainer/CompileButton

	quest_builder_graph.hide()

	new_folder_button.connect("button_down", self, "on_new_folder_button_pressed")
	new_quest_button.connect("button_down", self, "on_new_quest_button_pressed")
	new_chain_button.connect("button_down", self, "on_new_chain_button_pressed")
	compile_button.connect("button_down", self, "on_compile_button_pressed")

	# quest_tree
	quest_tree.connect("quest_item_pressed", self, "on_quest_item_pressed")
	quest_tree.connect("chain_item_pressed", self, "on_chain_item_pressed")

func _exit_tree():

	new_folder_button.disconnect("button_down", self, "on_new_folder_button_pressed")
	new_quest_button.disconnect("button_down", self, "on_new_quest_button_pressed")
	new_chain_button.disconnect("button_down", self, "on_new_chain_button_pressed")
	compile_button.disconnect("button_down", self, "on_compile_button_pressed")

func on_new_folder_button_pressed(): 
	quest_tree.create_folder("New Folder")

func on_new_quest_button_pressed():
	quest_tree.create_quest("New Quest")

func on_new_chain_button_pressed():
	quest_tree.create_chain("New Chain")

func on_compile_button_pressed():
	QuestCompiler.compile()

func on_quest_item_pressed(quest_id : String):
	quest_chain_graph.hide()
	quest_builder_graph.setup(quest_id)
	quest_builder_graph.show()

func on_chain_item_pressed(chain_id : String):
	quest_builder_graph.hide()
	# todo - chain setup
	quest_chain_graph.show()

