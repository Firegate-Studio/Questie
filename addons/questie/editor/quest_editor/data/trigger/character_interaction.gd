extends "res://addons/questie/editor/quest_editor/data/trigger/quest_trigger.gd"
class_name Trigger_CharacterInteraction

# the identifier of the character to interact with
export(String) var character_id

# the position of the character inside the characters database
export(int) var character_idx = -1