extends Control

var quest_list : VBoxContainer
var quest_title : LineEdit
var quest_description : TextEdit

func _enter_tree():
	quest_list = $"CenterContainer/Panel/VBoxContainer/HSplitContainer/ScrollContainer/QuestList"
	quest_title = $"CenterContainer/Panel/VBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/QuestTitle"
	quest_description = $"CenterContainer/Panel/VBoxContainer/HSplitContainer/VBoxContainer/QuestDescription"

	Questie.connect("quest_activated", self, "on_quest_activated")

	hide()

func _exit_tree(): pass

func on_quest_activated(quest_id):

	var quest = Questie.get_active_quest(quest_id)

	var quest_button = Button.new()
	quest_button.text = quest.title
	quest_button.connect("button_down", self, "update_quest_info", [quest])
	quest_button.show()

	quest_list.add_child(quest_button)

func update_quest_info(quest):
	quest_title.text = quest.title
	quest_description.text = quest.description

