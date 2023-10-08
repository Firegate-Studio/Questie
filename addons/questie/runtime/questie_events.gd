extends Node

signal kill(character_id, is_player)
signal talk(character_id)
signal interact_item(item_id)
signal interact_character(character_id)
signal player_enter_location(location_id)
signal player_exit_location(location_id)
signal character_alignment_changed(character_id, alignment_amount)
