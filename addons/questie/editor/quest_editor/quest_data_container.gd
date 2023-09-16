# Contains a bunch of sections holding quest data

tool
extends VBoxContainer

# Holds the quest title
onready var quest_title = get_node("title section/CenterContainer/HBoxContainer/LineEdit")

# Holds the quest description
onready var description = get_node("description section/CenterContainer/VBoxContainer/TextEdit")
