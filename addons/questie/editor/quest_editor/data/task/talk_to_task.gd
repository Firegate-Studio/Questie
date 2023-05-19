extends "res://addons/questie/editor/quest_editor/data/task/quest_task.gd"
class_name Task_TalkTo


# the character to talk
export(String) var character_id 

# the position of the character inside the characters database
export(int) var character_index = -1