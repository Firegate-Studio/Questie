tool
extends Control

var new_folder_btn : Button
var new_item_btn : Button
var questie_tree : QuestieFoldingTree

func _enter_tree():
    new_folder_btn = $"New Folder"
    new_item_btn = $"New Item"
    questie_tree = $QuestieFoldingTree

    new_folder_btn.connect("button_down", self, "on_new_folder")
    new_item_btn.connect("button_down", self, "on_new_item")

func on_new_folder():
    questie_tree.create_new_folder()

func on_new_item():
    questie_tree.create_new_item()

