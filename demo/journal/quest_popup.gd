extends Control

var quest_name : Label
var quest_description : TextEdit
var close_button : Button

func _enter_tree():
	quest_name = $Panel/CenterContainer/VBoxContainer/Label
	quest_description = $"Panel/CenterContainer/VBoxContainer/quest_description"
	close_button = $"Panel/CenterContainer/VBoxContainer/CenterContainer/close_button"

	Questie.connect("quest_activated", self, "handle_quest_activated")
	close_button.connect("button_down", self, "handle_close_button_pressed")

	hide()

func _exit_tree(): pass

func handle_quest_activated(quest_id):

	var quest = Questie.get_active_quest(quest_id)
	quest_name.text = quest.name
	quest_description.text = quest.description
	show()

func handle_close_button_pressed():
	hide()





