extends Node

var questie : QuestDirector

func _enter_tree():
	questie = get_parent().get_node("QuestDirector")

func _input(event):

	if Input.is_key_pressed(KEY_SPACE) and event.is_pressed() and not event.is_echo():
		questie.player_inventory.add_item(InventorySystem.weapons["Damascus"], 1)
		questie.player_inventory.add_item(InventorySystem.materials["Bacche di ginepro"], 1)
		questie.player_inventory.add_item(InventorySystem.materials["Seme di mandragora"], 1)
		questie.player_inventory.add_item(InventorySystem.materials["Foglie di fico sacro"], 1)
		
	if Input.is_key_pressed(KEY_Q) and event.is_pressed() and not event.is_echo():
		questie.player_inventory.debug()
