extends "res://addons/questie/editor/quest_editor/data/task/quest_task.gd"
class_name Task_Kill

# the number of characters to kill
export(int) var target_kills

# the identifier of the character to kill
export(String) var character_id

# the position of the character inside the characters database
export(int) var character_index = -1