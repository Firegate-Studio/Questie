extends Node

var questie 

var is_opened = false

func _enter_tree():

	questie = get_parent().get_node("QuestDirector")


func _input(event):

	if Input.is_key_pressed(KEY_TAB) and event.is_pressed() and not event.is_echo():

		if not is_opened:
			print("[questie]: opening inventory")
			questie.player_inventory.show()
			is_opened = true
		else:
			print("[questie]: closing inventory")
			questie.player_inventory.hide()
			is_opened = false
