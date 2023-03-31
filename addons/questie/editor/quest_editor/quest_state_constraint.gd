extends "res://addons/questie/editor/quest_editor/quest_constraint.gd"
class_name Constraint_QuestState

# The [UUID] of the quest to track
export(String) var quest

# The state of the quest
# **NB**: See [QuestData.QuestComplention] at [res://addons/questie/editor/quest_editor/quest_data.gd] for possible values
export(QuestData.QuestComplention) var state
