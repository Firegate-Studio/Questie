extends Node

var is_opened = false


func _input(event):

	if Input.is_key_pressed(KEY_TAB) and event.is_pressed() and not event.is_echo():

		if not is_opened:
			print("[questie]: opening inventory")
			Questie.player_inventory.show()
			is_opened = true
		else:
			print("[questie]: closing inventory")
			Questie.player_inventory.hide()
			is_opened = false
