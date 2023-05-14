extends Node
class_name QuestieEvents, "res://addons/questie/editor/icons/event_64x64.png"

signal Kill(character_id, is_player)
signal Talk(character_id)
signal interact_item(item_id)
signal interact_character(character_id)