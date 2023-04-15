tool
extends Panel

signal quest_selected(quest_id, part)
signal delete_button_pressed(part)

var quest_menu : MenuButton
var quest_name : LineEdit
var delete_button : Button

var quest_database = preload("res://questie/quest-db.tres")

# contains all quest identifiers 
var quest_map = {}

func _enter_tree(): 

	# Initial setup
	quest_menu = $"Padding/HBoxContainer/Quest Menu"
	quest_name = $"Padding/HBoxContainer/Quest Name"
	delete_button = $"Padding/HBoxContainer/Delete Button"

	setup_quest_menu()

	# subscribe events
	quest_menu.get_popup().connect("id_pressed", self, "handle_quest_menu_pressed")
	delete_button.connect("button_down", self, "delete_part")

func _exit_tree(): pass

# get all quests from the quest database
func get_all_quests_from_database()->Array: 
	var result = []

	if quest_database.data.size() == 0: return result

	for quest in quest_database.data:
		result.push_back(quest)

	return result

func setup_quest_menu():

	var popup = quest_menu.get_popup()
	popup.clear()

	var quest_list = get_all_quests_from_database()
	var popup_id = 0

	for quest in quest_list:

		popup.add_item(quest.title)
		quest_map[popup_id] = quest.uuid
		popup_id += 1

func handle_quest_menu_pressed(id): 

	var quest_id = quest_map[id]

	quest_name.text = quest_database.get_data(quest_map[id]).title

	emit_signal("quest_selected", quest_id, self)

func delete_part(): emit_signal("delete_button_pressed", self)
