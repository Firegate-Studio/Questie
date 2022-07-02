extends Node

var questie : QuestDirector

func _enter_tree():
    questie = get_parent().get_node("QuestDirector")

func _input(event):

    if Input.is_key_pressed(KEY_SPACE):
        questie.player_inventory.add_item(InventorySystem.weapons["Damascus"], 1)
