extends Node

var questie : Questie

func _enter_tree():
	questie = get_parent().get_node("Questie")

func _input(event):

	if Input.is_key_pressed(KEY_SPACE) and event.is_pressed() and not event.is_echo():
		questie.player_inventory.add_item(InventorySystem.consumables["Mana Potion"], 1)
		
	if Input.is_key_pressed(KEY_Q) and event.is_pressed() and not event.is_echo():
		questie.player_inventory.debug()

	if Input.is_key_pressed(KEY_R) and event.is_pressed() and not event.is_echo():
		questie.player_inventory.add_item(InventorySystem.materials["Verbena"], 1)
		questie.player_inventory.add_item(InventorySystem.materials["Water"], 1)
		questie.player_inventory.add_item(InventorySystem.materials["Moon Powder"], 1)
